//
//  CustomDataSourceVC.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/15/25.
//

import UIKit

class CustomDataSourceVCV2: UIViewController {
    
    var todoDataSource: TodoDataSourceV2? = nil
    var todoList: [TodoSolve] = []
    
    private lazy var todoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupTableView()
        setupLayout()
    }
    
    private func setupData() {
        todoList = TodoSolve.getDumies()
    }
    
    private func setupTableView() {
        self.todoDataSource = TodoDataSourceV2(todoList: todoList, tableView: todoTableView)
        self.todoTableView.dataSource = todoDataSource
        self.todoDataSource?.register(cellClass: TodoSolveCell.self, forCellReuseIdentifier: "TodoSolveCell")
        
        self.todoDataSource?.configureCell = { tableView, indexPath, cellData in
            guard let cell: TodoSolveCell = tableView.dequeueReusableCell(withIdentifier: "TodoSolveCell",
                                                                          for: indexPath) as? TodoSolveCell else {
                return UITableViewCell()
            }
            
            cell.configureCell(cellData: cellData)
            cell.isDoneChange = { [weak self] id, isDone in
                guard let self = self else { return }
                
                // todo.id와 클로저로 들어온 id
                if let foundIndex = todoDataSource?.todoList.firstIndex(where: { $0.id == id }) {
                    self.todoDataSource?.todoList[foundIndex].isDone = isDone
                    
                    // 새로고침
                    DispatchQueue.main.async {
                        tableView.reloadRows(at: [IndexPath(row: foundIndex, section: 0)], with: .fade)
                    }
                }
            }
            return cell
        }
        
        // MARK: - 3초 뒤 데이터 재할당
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.todoDataSource?.setData(newValue: TodoSolve.getDumies(count: 3))
        }
    }
    
    private func setupLayout() {
        view.addSubview(todoTableView)
        NSLayoutConstraint.activate([
            todoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            todoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            todoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
