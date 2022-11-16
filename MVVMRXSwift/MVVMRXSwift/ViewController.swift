//
//  ViewController.swift
//  MVVMRXSwift
//
//  Created by Usr_Prime on 16/11/22.
//

import UIKit
import RxSwift
import RxCocoa

struct User: Codable {
    let userID, id: Int
    let title, body: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

class ViewModel {
    var users = BehaviorSubject(value: [User]())
    
    func fetchUsers() {
        let adressUrl = "https://jsonplaceholder.typicode.com/posts"
        let url = URL(string: adressUrl)
        let task = URLSession.shared.dataTask(with: url!) { ( data, response, error ) in
            guard let data = data else { return }

            do {
                let responseData = try JSONDecoder().decode([User].self, from: data)
                self.users.on(.next(responseData))
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

class ViewController: UIViewController {

    private var viewModel = ViewModel()
    private var bag = DisposeBag()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserTableViewCell.self,
                           forCellReuseIdentifier: UserTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        viewModel.fetchUsers()
        bindTableView()
        setupUI()
    }

    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag)
        viewModel.users.bind(to: tableView.rx.items(
            cellIdentifier: UserTableViewCell.identifier,
            cellType: UserTableViewCell.self)) { (row, item, cell) in
                cell.textLabel?.text = item.title
                cell.detailTextLabel?.text = "\(item.id)"
        }.disposed(by: bag)
    }
    
    func setupUI() {
        tableView.rx.modelSelected(User.self).bind { user in
            print(user)
        }.disposed(by: bag)
    }
    
}

extension ViewController: UITableViewDelegate {}
