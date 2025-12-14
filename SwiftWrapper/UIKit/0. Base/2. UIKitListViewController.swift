//
//  UIKitListViewController.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 10/26/25.
//

import UIKit

final class UIKitListViewController: UIViewController {
    
    let listVC = ListViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 👉 리스트 화면에서는 네비게이션 바 숨김
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 👉 화면을 떠날 때(= 상세 화면 진입 전) 다시 보이게
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addChild(listVC)
        view.addSubview(listVC.view)
        listVC.view.translatesAutoresizingMaskIntoConstraints = false
        listVC.didMove(toParent: self)
        NSLayoutConstraint.activate([
            listVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            listVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            listVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        listVC.navigationControllerRef = self.navigationController
        listVC.applyMenu(menuData)
        // self.title = "메뉴"
    }
}

#Preview {
    UINavigationController(rootViewController: UIKitListViewController())
}
