//
//  TestViewController.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/16/25.
//

import UIKit

// MARK: - ViewController
final class CustomCollectionViewControllerV2: UIViewController {

    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    private lazy var adapter =
        TossCollectionViewAdapter<TossListRowItemModel>(
            collectionView: collectionView
        )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(collectionView)
        collectionView.frame = view.bounds

        adapter.update(sections: [
            TossCollectionSection(
                id: "main",
                items: [
                    TossListRowItemModel(id: "1", amount: "116,748"),
                    TossListRowItemModel(id: "2", amount: "42,000")
                ]
            )
        ])

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.adapter.update(sections: [
                TossCollectionSection(
                    id: "main",
                    items: [
                        TossListRowItemModel(id: "1", amount: "116,748"),
                        TossListRowItemModel(id: "2", amount: "42,000"),
                        TossListRowItemModel(id: "1", amount: "200,000"),
                        TossListRowItemModel(id: "2", amount: "42,000"),
                        TossListRowItemModel(id: "3", amount: "NEW")
                    ]
                )
            ])
        }
    }
}
