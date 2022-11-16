//
//  UserTableViewCell.swift
//  MVVMRXSwift
//
//  Created by Usr_Prime on 16/11/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    static let identifier = "UserTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: UserTableViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
