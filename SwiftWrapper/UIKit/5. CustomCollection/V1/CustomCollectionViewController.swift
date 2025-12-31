//
//  TestViewController.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/16/25.
//

import UIKit

class CustomCollectionViewController: UIViewController {

    private let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )

        private lazy var adapter =
            CollectionViewAdapter(collectionView: collectionView)

        override func viewDidLoad() {
            super.viewDidLoad()

            view.addSubview(collectionView)
            collectionView.frame = view.bounds

            // 🔹 ViewModel이 할 일
            let section = CollectionSection(items: [
                ListRowItemModel(amount: "116,748"),
                ListRowItemModel(amount: "42,000")
            ])

            adapter.update(sections: [section])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.adapter.update(sections: [
                    CollectionSection(items: [
                        ListRowItemModel(amount: "116,748"),
                        ListRowItemModel(amount: "42,000"),
                        ListRowItemModel(amount: "42,000"),
                        ListRowItemModel(amount: "42,000")
                    ])
                ])
            }
        }
}
