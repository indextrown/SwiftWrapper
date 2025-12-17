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
    case section2 = "DataSource"
    case section3 = "RxDataSource"
    case section4 = "CustomCollection"
}

let menuData: [MenuSection: [MenuItem]] = [
    .section1: [
        MenuItem(title: "스크롤시 셀 데이터 초기화", viewControllerType: TodosVC.self),
        MenuItem(title: "스크롤시 셀 데이터 재사용", viewControllerType: TodosSolveVC.self),
    ],
    
    .section2: [
        MenuItem(title: "커스텀 데이터 소스", viewControllerType: CustomDataSourceVC.self),
        MenuItem(title: "커스텀 데이터 소스 V2", viewControllerType: CustomDataSourceVCV2.self),
        MenuItem(title: "커스텀 데이터 소스 V3", viewControllerType: CustomDataSourceVCV3.self),
        MenuItem(title: "커스텀 데이터 소스 V4", viewControllerType: CustomDataSourceVCV3.self)
    ],
    
    .section3: [
        MenuItem(title: "RxDataSource", viewControllerType: RxDataSourceVC.self),
        MenuItem(title: "RxDataSource CRUD", viewControllerType: RxDataSourceVCV2.self),
        MenuItem(title: "RxDataSource Cell도 Rx 스타일로 변경", viewControllerType: RxDataSourceVCV3.self),
        MenuItem(title: "RxDataSource 멀티섹션", viewControllerType: RxDataSourceVCV4.self),
    ],
    .section4: [
        MenuItem(title: "CustomCollectionView", viewControllerType: CustomCollectionViewController.self),
        MenuItem(title: "CustomCollectionViewControllerV2", viewControllerType: CustomCollectionViewControllerV2.self),

    ],
]



