//
//  User.swift
//  MVVMRXSwift
//
//  Created by Usr_Prime on 16/11/22.
//

import Foundation

struct User: Codable {
    let userID, id: Int
    let title, body: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
