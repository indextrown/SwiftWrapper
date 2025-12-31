//
//  DiffableTodo.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/17/25.
//

import UIKit
import Fakery

struct DiffableTodoSection: Hashable {
    let id: UUID
    
    let title: String
    let body: String
    let rows: [DiffableTodo]
    
    init() {
        self.id = UUID()
        self.title = "섹션 타이틀입니다: \(id.uuidString.prefix(8))"
        self.body = "섹션 바디입니다: \(id.uuidString.prefix(8))"
        self.rows = DiffableTodo.getDumies()
    }
    
    static func getDummies(count: Int = 10) -> [DiffableTodoSection] {
        return (1...count).map { _ in DiffableTodoSection() }
    }
     
    static func == (lhs: DiffableTodoSection, rhs: DiffableTodoSection) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct DiffableTodo: Hashable {
    let id: UUID = UUID()
    let title: String
    var isDone: Bool
    
    init(title: String? = nil, isDone: Bool = false) {
        self.title = title ?? "타이틀: \(id.uuidString.prefix(8))"
        self.isDone = isDone
    }
    
    static func getDumies(count: Int = 10) -> [DiffableTodo] {
        let faker = Faker(locale: "ko")
        
        return (1...count).map { _ in
            let firstName = faker.name.firstName()
            let lastName = faker.name.lastName()
            let title = "\(lastName) \(firstName)"
            return DiffableTodo(title: title, isDone: false)
        }
    }
    
    static func getDummy() -> DiffableTodo {
        let faker = Faker(locale: "ko")
        
        let firstName = faker.name.firstName()
        let lastName = faker.name.lastName()
        let title = "\(lastName) \(firstName)"
        return DiffableTodo(title: title, isDone: false)
    }
    
    static func == (lhs: DiffableTodo, rhs: DiffableTodo) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
