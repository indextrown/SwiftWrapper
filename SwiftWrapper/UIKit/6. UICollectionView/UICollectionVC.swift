//
//  UICollectionVC.swift
//  SwiftWrapper
//
//  Created by 김동현 on 1/1/26.
//
// https://developer.apple.com/documentation/uikit/uicollectionview
// https://developer.apple.com/documentation/uikit/uicollectionview/collectionviewlayout
// https://maggie-chae.tistory.com/174
// https://clamp-coding.tistory.com/388
// https://developer.apple.com/documentation/uikit/uicollectionviewcontroller
// https://apple-apeach.tistory.com/25
/**
 UICollectionView
 - 정렬된 데이터 항목 모음을 관리하고 사용자 정의 가능한 레이아웃을 사용하여 표시하는 객체
 
 UICollectionView구조
 - 헤더뷰를 넣을 수 있는 공간
 */

import UIKit

class UICollectionVC: UIViewController {
    
    private let items = Array(1...20)
    
    // 1. 컬렉션 뷰
    private lazy var collectionView: UICollectionView = {
        // 레이아웃 설정
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100) // 셀 크기 설정
        layout.minimumLineSpacing = 10                                      // 셀 간격 설정
        layout.minimumInteritemSpacing = 10                                 // 행 간 간격 설정
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.dataSource = self
        cv.delegate = self
        cv.register(CollectionCell.self, forCellWithReuseIdentifier: "CollectionCell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeUI()
    }
    
    private func makeUI() {
        title = "UICollectionView 예제"
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension UICollectionVC: UICollectionViewDataSource {
    // 섹션당 아이템 수를 반환하는 메서드
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    // 각 셀을 구성하는 메서드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(text: "Item \(items[indexPath.item])")
        return cell
    }
}

extension UICollectionVC: UICollectionViewDelegate {
    // 셀 선택시 호출되는 메서드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("선택된 셀: \(indexPath.row)")
    }
}

/*
extension UICollectionVC: UICollectionViewDelegateFlowLayout {
    // 셀 크기를 동적으로 계산
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let baseSize: CGFloat = 100
        let size = baseSize + CGFloat(indexPath.item)
        return CGSize(width: size, height: size)
    }
}
 */

// MARK: - 셀 크기와 간격 계산을 담당(고정 값이 아닌 화면의 크기에 따라 셀 크기가 변경되거나 섹션별 다른 레이아웃 또는 동적UI를 그릴때 쓴다)
extension UICollectionVC: UICollectionViewDelegateFlowLayout {
    // 컬렉션뷰가 셀 크기를 설정(반환 값이 셀 크기)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3            // 한줄에 몇 개
        let spacing: CGFloat = 10           // 셀 사이 간격(가로, 세로)
        let sectionInset: CGFloat = 0       // 화면 좌우 여백(없으면 0)
        
        // 전체에서 간격 빼기
        let totalSpacing = (columns - 1) * spacing + (sectionInset * 2)
        // 실제 사용 가능한 폭
        let availableWidth = collectionView.bounds.width - totalSpacing
        
        // 최종 셀 크기 계산(정사각형)
        let cellSize = floor(availableWidth / columns)
        return CGSize(width: cellSize, height: cellSize)
    }
    
    // 세로 간격
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    // 가로 간격
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


#Preview {
    UICollectionVC()
}
