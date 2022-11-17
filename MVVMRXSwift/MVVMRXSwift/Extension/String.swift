//
//  String.swift
//  MVVMRXSwift
//
//  Created by Usr_Prime on 17/11/22.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let regex = try! NSRegularExpression(pattern: emailRegEx,
                                             options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
