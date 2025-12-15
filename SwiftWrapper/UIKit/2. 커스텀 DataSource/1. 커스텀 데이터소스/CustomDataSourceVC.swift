//
//  CustomDataSourceVC.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/15/25.
//

import UIKit

class CustomDataSourceVC: UIViewController {
    
    var todoDataSource: TodoDataSource? = nil
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
        todoDataSource = TodoDataSource(todoList: todoList, tableView: todoTableView)
        todoTableView.dataSource = todoDataSource
        todoDataSource?.register(cellClass: TodoSolveCell.self, forCellReuseIdentifier: "TodoSolveCell")
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
