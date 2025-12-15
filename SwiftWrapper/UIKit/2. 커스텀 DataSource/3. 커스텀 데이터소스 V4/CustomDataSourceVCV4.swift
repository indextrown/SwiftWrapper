//
//  CustomDataSourceVC.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/15/25.
//

import UIKit

class CustomDataSourceVCV4: UIViewController {
    
    var todoDataSource: TodoDataSourceV4? = nil
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
        self.todoDataSource = TodoDataSourceV4(todoList: self.todoList, tableView: todoTableView)
        self.todoDataSource?.register(cellClass: TodoSolveCell.self, forCellReuseIdentifier: "TodoSolveCell")
        self.todoTableView.dataSource = todoDataSource
        self.todoDataSource?.configureCell = { dataSource, tableView, index, cellData, cell in
            cell.configureCell(cellData: cellData)
            cell.isDoneChange = { [weak self] id, isDone in
                guard let self = self, let datasource = self.todoDataSource else { return }
                datasource.todoList[index].isDone = isDone
                
                // 새로고침
                DispatchQueue.main.async {
                    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                }
            }
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
