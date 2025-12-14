//
//  SampleVC.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 10/26/25.
//

import UIKit

final class TodosVC: UIViewController {
    
    var todoList: [Todo] = []
    
    private lazy var todoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupData()
        setupTableView()
        setupLayout()
    }
    
    private func setupData() {
        todoList = Todo.getDumies()
    }
    
    private func setupTableView() {
        todoTableView.dataSource = self
        todoTableView.delegate = self
        todoTableView.register(
            TodoCell.self,
            forCellReuseIdentifier: "TodoCell"
        )
        view.addSubview(todoTableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            todoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            todoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            todoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension TodosVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TodoCell = tableView.dequeueReusableCell(withIdentifier: "TodoCell",
                                                                 for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        
        let cellData = todoList[indexPath.row]
        cell.configureCell(cellData: cellData)
        return cell
    }
}

extension TodosVC: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didEndDisplaying cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        print()
    }
}
