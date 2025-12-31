//
//  DiffableDataSourceVC.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/17/25.
//

import UIKit

/*
 Diff = 아이템들간의 서로 다름을 아는 의미이다.
 - 애니메이션 처리가 자연스럽게 된다
 - 테이블 로드 방식이 기존 테이블 방식과 다르다
 
 dataSource.apply(스냅샷) - 찍어둔 사진으로 반영
 - 스냅샷을 통해(사진을 찍어서) datasource에 apply를 한다
 */


final class DiffableDataSourceVC: UIViewController {
    
    var sections: [DiffableTodoSection] = DiffableTodoSection.getDummies()
    var snapshot = NSDiffableDataSourceSnapshot<DiffableTodoSection, DiffableTodo>()
    var dataSource: UITableViewDiffableDataSource<DiffableTodoSection, DiffableTodo>? = nil
    
    private lazy var todoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "DiffableDataSourceVC"
        setupUI()
        setupConstraints()
        setupTableView()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        view.addSubview(todoTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            todoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            todoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            todoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func setupTableView() {
        
        todoTableView.delegate = self
        todoTableView.register(DiffableTodoCell.self,
                               forCellReuseIdentifier: DiffableTodoCell.reuseIdentifier)
        
        self.dataSource = makeDiffableDataSource()
        
        // 1. 스냅샷 준비
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.rows, toSection: section)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
        
    } // viewDidLoad
    
    
    // makeDiffableDataSource
    private func makeDiffableDataSource() -> UITableViewDiffableDataSource<DiffableTodoSection, DiffableTodo> {
        let dataSource =  UITableViewDiffableDataSource<DiffableTodoSection, DiffableTodo>(tableView: todoTableView) { tableView, indexPath,  item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DiffableTodoCell.reuseIdentifier, for: indexPath) as? DiffableTodoCell else {
                return UITableViewCell()
            }
            
            // 셀 설정
            cell.configureCell(cellData: item)
            return cell
        }
        
        return dataSource
    }
}

extension DiffableDataSourceVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.text = "Header: " + self.sections[section].title
        headerLabel.backgroundColor = .systemOrange.withAlphaComponent(0.4)
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerLabel = UILabel()
        footerLabel.text = "Footer: " + self.sections[section].title
        footerLabel.backgroundColor = .systemBlue .withAlphaComponent(0.4)
        return footerLabel
    }
}

