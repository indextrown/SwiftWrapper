//
//  MenuItem.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/14/25.
//

import UIKit

// 각 셀에 표시할 메뉴 정보
struct MenuItem: Hashable {
    let title: String
    let viewControllerType: UIViewController.Type

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }

    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        lhs.title == rhs.title
    }
}


// 섹션
enum MenuSection: String, CaseIterable {
    case section1 = "섹션1"
}

let menuData: [MenuSection: [MenuItem]] = [
    .section1: [
        MenuItem(title: "샘플 테이블", viewControllerType: TodosVC.self)
    ],
]
