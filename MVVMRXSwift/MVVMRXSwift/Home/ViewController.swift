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
        
        viewModel.fetchUsers()
        bindTableView()
        setupView()
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
    
    func setupView() {
        self.navigationItem.title = "Users".uppercased()
        self.view.addSubview(tableView)
        
        let addButton = UIBarButtonItem(title: "add",
                                  style: .done,
                                  target: self,
                                  action: #selector(onTapAdd))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func setupUI() {
        // MARK: SELECIONAR -> EDITAR CELL
        tableView.rx.modelSelected(User.self).bind { user in
            print(user)
        }.disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let alert = UIAlertController(title: "Note",
                                          message: "Edit Note",
                                          preferredStyle: .alert)
            alert.addTextField { textField in
                
            }
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
                let textField = alert.textFields![0] as UITextField
                guard let text = textField.text else { return }
                if !text.isEmpty {
                    self.viewModel.editUser(title: text, index: indexPath.row)
                }
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: bag)
        
        // MARK: DELETAR
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.deleteUser(index: indexPath.row)
        }).disposed(by: bag)
    }
    
    // MARK: MÉTODOS
    @objc func onTapAdd() {
        let user = User(userID: 451524,
                        id: 545451,
                        title: "CodeLib",
                        body: "RxSwift Crud")
        viewModel.addUser(user: user)
    }
    
}

extension ViewController: UITableViewDelegate {}
