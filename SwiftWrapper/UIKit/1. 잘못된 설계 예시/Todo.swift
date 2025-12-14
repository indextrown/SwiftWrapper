//
//  Todo.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/14/25.
//

import UIKit
import Fakery

struct Todo {
    let id: UUID = UUID()
    let title: String
    let isDone: Bool
    
    init(title: String? = nil, isDone: Bool = false) {
        self.title = title ?? "타이틀: \(id.uuidString.prefix(8))"
        self.isDone = isDone
    }
    
    static func getDumies(count: Int = 10) -> [Todo] {
        let faker = Faker(locale: "ko")
        
        return (1...count).map { _ in
            let firstName = faker.name.firstName()
            let lastName = faker.name.lastName()
            let title = "\(lastName) \(firstName)"
            return Todo(title: title, isDone: false)
        }
    }
}
