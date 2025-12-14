//
//  SwiftWrapperApp.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/14/25.
//

import SwiftUI

@main
struct SwiftWrapperApp: App {
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()     // 탭바의 배경을 불투명(opaque)
        tabBarAppearance.backgroundColor = .systemBackground // 탭바의 배경색을 시스템 기본 배경색(라이트 모드에서는 흰색, 다크 모드에서는 검은색)
        UITabBar.appearance().standardAppearance = tabBarAppearance // 앱 전체의 기본 탭바 디자인으로 적용

        // iOS 15 이상에서 스크롤 위치에 따라 디자인이 바뀌지 않도록 통일
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
