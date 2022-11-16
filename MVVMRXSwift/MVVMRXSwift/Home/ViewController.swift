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
        self.title = "Users"
        self.view.addSubview(tableView)
        
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
        // MARK: CLICAR
        tableView.rx.modelSelected(User.self).bind { user in
            print(user)
        }.disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print(indexPath.row)
        }).disposed(by: bag)
        
        // MARK: DELETAR
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.deleteUser(index: indexPath.row)
        }).disposed(by: bag)
        
        // MARK: EDITAR
        
        
    }
    
}

extension ViewController: UITableViewDelegate {}
