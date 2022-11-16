//
//  ViewModel.swift
//  MVVMRXSwift
//
//  Created by Usr_Prime on 16/11/22.
//

import RxSwift
import RxCocoa

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
    
    func addUser(user: User) {
        
    }
    
    func deleteUser(index: Int) {
        guard var users = try? users.value() else { return }
        users.remove(at: index)
        self.users.on(.next(users))
    }
    
    func editUser(title: String, index: Int) {
        
    }
}
