//
//  ViewModel.swift
//  MVVMRXSwift
//
//  Created by Usr_Prime on 16/11/22.
//

import RxSwift
import RxCocoa
import Differentiator

class ViewModel {
    var users = BehaviorSubject(value: [SectionModel(model: "", items: [User]())])
    
    func fetchUsers() {
        let adressUrl = "https://jsonplaceholder.typicode.com/posts"
        let url = URL(string: adressUrl)
        let task = URLSession.shared.dataTask(with: url!) { ( data, response, error ) in
            guard let data = data else { return }

            do {
                let responseData = try JSONDecoder().decode([User].self, from: data)
                let sectionUser = SectionModel(model: "First",
                                               items: [User(userID: 0,
                                                            id: 1,
                                                            title: "CodeLib",
                                                            body: "Youtube demo")])
                let secondSection = SectionModel(model: "Second", items: responseData)
                self.users.on(.next([sectionUser, secondSection]))
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func addUser(user: User) {
        guard var sections = try? users.value() else { return }
        var currentSection = sections[0]
        currentSection.items.append(User(userID: 2,
                                          id: 32,
                                          title: "New data",
                                          body: "Teste"))
        sections[0] = currentSection
        self.users.onNext(sections)
        
//        users.insert(user, at: 0)
//        self.users.on(.next(users))
    }
    
    func deleteUser(indexPath: IndexPath) {
        guard var sections = try? users.value() else { return }
        var currentSections = sections[indexPath.section]
        currentSections.items.remove(at: indexPath.row)
        sections[indexPath.section] = currentSections
        self.users.onNext(sections)
        
//        users.remove(at: index)
//        self.users.on(.next(users))
    }
    
    func editUser(title: String, indexPath: IndexPath) {
        guard var sections = try? users.value() else { return }
        var currentSections = sections[indexPath.section]
        currentSections.items[indexPath.row].title = title
        sections[indexPath.section] = currentSections
        self.users.onNext(sections)
        
//        users[index].title = title
//        self.users.on(.next(users))
    }
}
