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
    case section1 = "테이블 기본 개념"
}

let menuData: [MenuSection: [MenuItem]] = [
    .section1: [
        MenuItem(title: "스크롤시 셀 데이터 초기화", viewControllerType: TodosVC.self),
        MenuItem(title: "스크롤시 셀 데이터 재사용", viewControllerType: TodosSolveVC.self),
        MenuItem(title: "커스텀 데이터 소스", viewControllerType: CustomDataSourceVC.self),
        MenuItem(title: "커스텀 데이터 소스 V2", viewControllerType: CustomDataSourceVCV2.self),
        MenuItem(title: "커스텀 데이터 소스 V3", viewControllerType: CustomDataSourceVCV3.self),
        MenuItem(title: "커스텀 데이터 소스 V4", viewControllerType: CustomDataSourceVCV3.self)
    ],
]
