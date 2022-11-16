//
//  User.swift
//  MVVMRXSwift
//
//  Created by Usr_Prime on 16/11/22.
//

import Foundation

struct User: Codable {
    let userID: Int
    let id: Int
    var title: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
