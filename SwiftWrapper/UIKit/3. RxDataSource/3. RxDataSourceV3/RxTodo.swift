//
//  RxTodo.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/16/25.
//

import UIKit
import Fakery

struct RxTodo {
    let id: UUID = UUID()
    let title: String
    var isDone: Bool
    
    init(title: String? = nil, isDone: Bool = false) {
        self.title = title ?? "타이틀: \(id.uuidString.prefix(8))"
        self.isDone = isDone
    }
    
    static func getDumies(count: Int = 10) -> [RxTodo] {
        let faker = Faker(locale: "ko")
        
        return (1...count).map { _ in
            let firstName = faker.name.firstName()
            let lastName = faker.name.lastName()
            let title = "\(lastName) \(firstName)"
            return RxTodo(title: title, isDone: false)
        }
    }
    
    static func getDummy() -> RxTodo {
        let faker = Faker(locale: "ko")
        
        let firstName = faker.name.firstName()
        let lastName = faker.name.lastName()
        let title = "\(lastName) \(firstName)"
        return RxTodo(title: title, isDone: false)
    }
}
