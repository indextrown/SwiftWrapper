//
//  UIViewController+.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/14/25.
//

import UIKit
import SwiftUI

// MARK: - 네비게이션포함버전(UIKit VC를 SwiftUI에서 사용할 때 쓰는 표준 방식)
extension UIViewController {
    struct VCWrapper: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UINavigationController {
            let root = UIKitListViewController()
            let nav = UINavigationController(rootViewController: root)
            return nav
        }

        func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    }

    static func getRepresentablee() -> some View {
        VCWrapper()
            .ignoresSafeArea(.all, edges: .top) // ✅ 상단 safeArea 영향 제거
    }
}
