//
//  CellItemModelType.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/16/25.
//

import UIKit

/**
 컬렉션뷰의 셀 타입
 - diff 계산을 위해 hashable채택
 - 값이 바뀌면 update/reload 자동 판단
 */
protocol CellItemModelType: Hashable {
    
    /// 어떤 UICollectionViewCell을 써야 하는지 결정
    /// Adapter가 이걸 보고 Cell을 만든다
    var viewType: UICollectionViewCell.Type { get }
}

/**
 셀 사이즈 계산 책임을 모델로 위임
 */
protocol FlowSizeable {
    
    /// containerWidth 기준으로 셀 크기 졀정
    func size(containerWidth: CGFloat) -> CGSize
}

/**
 CellItemModel을 받아서 화면에 그릴 수 있다
 */
protocol CellItemModelBindable {
    /// 어떤 모델이 와도 받을 수 있도록 추상화
    func bind(cellItemModel: any CellItemModelType)
}

/// 🔹 컬렉션뷰 섹션
struct CollectionSection {
    let items: [any CellItemModelType]
}


/**
 리스트 한 줄을 표현하는 모델
 */
final class ListRowItemModel: CellItemModelType, FlowSizeable {
    
    /// 셀에 표시할 데이터
    let amount: String
    
    init(amount: String) {
        self.amount = amount
    }
    
    // MARK: - 어떤 셀을 쓸지
    var viewType: UICollectionViewCell.Type {
        ListRowCell.self
    }
    
    // MARK: - 사이즈 전략
    func size(containerWidth: CGFloat) -> CGSize {
        // 항상 동일하 높이를 갖는 셀
        return CGSize(width: containerWidth, height: 56)
    }
    
    // MARK: - diff를 위한 hash
    func hash(into hasher: inout Hasher) {
        hasher.combine(amount)
    }
    
    static func == (lhs: ListRowItemModel, rhs: ListRowItemModel) -> Bool {
        return lhs.amount == rhs.amount
    }
}

/**
 실제 Cell 구현
 **/
final class ListRowCell: UICollectionViewCell, CellItemModelBindable {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        
        // 레이아웃 단순화
        label.frame = contentView.bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder: NSCoder) {
        fatalError("스토리보드 안 씀")
    }

    func bind(cellItemModel: any CellItemModelType) {

        // 🔹 이 셀이 원하는 모델로 캐스팅
        guard let model = cellItemModel as? ListRowItemModel else { return }

        // 🔹 화면 그리기
        label.text = model.amount
    }
}

final class CollectionViewAdapter: NSObject {

    private let collectionView: UICollectionView

    /// 현재 화면에 그릴 섹션들
    private var sections: [CollectionSection] = []

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()

        // Adapter가 모든 책임을 진다
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    /// 🔹 ViewModel은 이것만 호출
    func update(sections: [CollectionSection]) {
        self.sections = sections

        // 실제 토스에선 diff 처리
        collectionView.reloadData()
    }
}

extension CollectionViewAdapter: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = sections[indexPath.section].items[indexPath.item]

        // 🔹 모델이 어떤 셀인지 알려준다
        let cellType = item.viewType

        // 🔹 동적 셀 등록
        collectionView.register(
            cellType,
            forCellWithReuseIdentifier: "\(cellType)"
        )

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "\(cellType)",
            for: indexPath
        )

        // 🔹 모델 → 셀 바인딩
        (cell as? CellItemModelBindable)?
            .bind(cellItemModel: item)

        return cell
    }
}

extension CollectionViewAdapter: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let item = sections[indexPath.section].items[indexPath.item]

        // 🔹 사이즈 계산 가능한 모델만 처리
        guard let sizeable = item as? FlowSizeable else {
            return .zero
        }

        return sizeable.size(
            containerWidth: collectionView.bounds.width
        )
    }
}
