//
//  ViewController.swift
//  MVVMRXSwift
//
//  Created by Usr_Prime on 16/11/22.
//

import UIKit
import RxSwift
import RxCocoa

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
