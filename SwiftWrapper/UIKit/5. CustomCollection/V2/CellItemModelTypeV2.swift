//
//  TossCollectionView.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/16/25.
//
//

import UIKit
import DifferenceKit

// MARK: - Size Strategy
protocol TossFlowSizeable {
    func size(containerWidth: CGFloat) -> CGSize
}

// MARK: - Cell
final class TossListRowCell: UICollectionViewCell {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .systemGray6
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left

        contentView.addSubview(label)
        label.frame = contentView.bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func bind(_ model: TossListRowItemModel) {
        label.text = model.amount
    }
}

// MARK: - ItemModel
final class TossListRowItemModel: Differentiable, TossFlowSizeable {

    let id: String
    let amount: String

    init(id: String, amount: String) {
        self.id = id
        self.amount = amount
    }

    // Diff identity
    var differenceIdentifier: String {
        id
    }

    // Diff content
    func isContentEqual(to source: TossListRowItemModel) -> Bool {
        amount == source.amount
    }

    func size(containerWidth: CGFloat) -> CGSize {
        CGSize(width: containerWidth, height: 56)
    }
}

// MARK: - Section (⭐️ 핵심)
struct TossCollectionSection<Item: Differentiable>: DifferentiableSection {

    typealias Element = Item
    typealias Collection = [Item]

    let id: String
    var elements: [Item]

    init(id: String, items: [Item]) {
        self.id = id
        self.elements = items
    }

    // ⭐️ DifferenceKit이 요구하는 핵심 이니셜라이저
    init<C>(
        source: TossCollectionSection<Item>,
        elements: C
    ) where C: Swift.Collection, C.Element == Item {
        self.id = source.id
        self.elements = Array(elements)
    }

    // MARK: - Differentiable
    var differenceIdentifier: String {
        id
    }

    func isContentEqual(to source: TossCollectionSection<Item>) -> Bool {
        true
    }
}


// MARK: - Adapter
final class TossCollectionViewAdapter<Item: Differentiable>:
    NSObject,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {

    private let collectionView: UICollectionView
    private var sections: [TossCollectionSection<Item>] = []

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func update(sections: [TossCollectionSection<Item>]) {

        // ⭐️ 최초 로딩은 diff 사용 ❌
        if self.sections.isEmpty {
            self.sections = sections
            collectionView.reloadData()
            return
        }

        // ⭐️ 이후부터 diff
        let changeset = StagedChangeset(
            source: self.sections,
            target: sections
        )

        collectionView.reload(using: changeset) { data in
            self.sections = data
        }
    }

    // MARK: - DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        sections[section].elements.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = sections[indexPath.section].elements[indexPath.item]
        let model = item as! TossListRowItemModel

        let reuseID = "TossListRowCell"
        collectionView.register(
            TossListRowCell.self,
            forCellWithReuseIdentifier: reuseID
        )

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseID,
            for: indexPath
        ) as! TossListRowCell

        cell.bind(model)
        return cell
    }

    // MARK: - Layout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let item = sections[indexPath.section].elements[indexPath.item]
        let model = item as! TossListRowItemModel
        return model.size(containerWidth: collectionView.bounds.width)
    }
}


//import UIKit
//import DifferenceKit
//
//protocol TossCellItemModelType {
//    var identifier: String { get }
//    var viewType: UICollectionViewCell.Type { get }
//}
//
//protocol TossFlowSizeable {
//    func size(containerWidth: CGFloat) -> CGSize
//}
//
//protocol TossCellItemModelBindable {
//    func bind(cellItemModel: TossCellItemModelType)
//}
//
//final class TossListRowItemModel:
//    TossCellItemModelType,
//    TossFlowSizeable,
//    Differentiable {
//
//    let id: String
//    let amount: String
//
//    init(id: String, amount: String) {
//        self.id = id
//        self.amount = amount
//    }
//
//    // MARK: - Identity
//    var identifier: String { id }
//
//    var differenceIdentifier: String { id }
//
//    func isContentEqual(to source: TossListRowItemModel) -> Bool {
//        amount == source.amount
//    }
//
//    // MARK: - View
//    var viewType: UICollectionViewCell.Type {
//        ListRowCell.self
//    }
//
//    // MARK: - Size
//    func size(containerWidth: CGFloat) -> CGSize {
//        CGSize(width: containerWidth, height: 56)
//    }
//}
//
//final class TossListRowCell:
//    UICollectionViewCell,
//    TossCellItemModelBindable {
//
//    private let label = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        contentView.backgroundColor = .systemGray6
//        label.font = .systemFont(ofSize: 16, weight: .medium)
//        label.textAlignment = .left
//
//        contentView.addSubview(label)
//        label.frame = contentView.bounds
//        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//
//    func bind(cellItemModel: TossCellItemModelType) {
//        guard let model = cellItemModel as? TossListRowItemModel else { return }
//        label.text = model.amount
//    }
//}
//
//struct TossCollectionSection {
//    let id: String
//    let items: [TossCellItemModelType]
//}
//
//extension TossCollectionSection: Differentiable {
//
//    var differenceIdentifier: String { id }
//
//    func isContentEqual(to source: TossCollectionSection) -> Bool {
//        false
//    }
//}
//
//final class TossCollectionViewAdapter: NSObject {
//
//    private let collectionView: UICollectionView
//    private var sections: [TossCollectionSection] = []
//
//    init(collectionView: UICollectionView) {
//        self.collectionView = collectionView
//        super.init()
//
//        collectionView.dataSource = self
//        collectionView.delegate = self
//    }
//
//    func update(sections: [TossCollectionSection]) {
//        let changeset = StagedChangeset(
//            source: self.sections,
//            target: sections
//        )
//
//        collectionView.reload(using: changeset) { data in
//            self.sections = data
//        }
//    }
//}
//
//extension TossCollectionViewAdapter: UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        sections.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        numberOfItemsInSection section: Int) -> Int {
//        sections[section].items.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let item = sections[indexPath.section].items[indexPath.item]
//        let cellType = item.viewType
//        let reuseID = String(describing: cellType)
//
//        collectionView.register(cellType, forCellWithReuseIdentifier: reuseID)
//
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: reuseID,
//            for: indexPath
//        )
//
//        (cell as? TossCellItemModelBindable)?
//            .bind(cellItemModel: item)
//
//        return cell
//    }
//}
//
//extension TossCollectionViewAdapter: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let item = sections[indexPath.section].items[indexPath.item]
//
//        guard let sizeable = item as? TossFlowSizeable else {
//            return .zero
//        }
//
//        return sizeable.size(containerWidth: collectionView.bounds.width)
//    }
//}
