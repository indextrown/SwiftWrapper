//
//  SampleVC.swift
//  UIComponentTutorial
//
//  Created by 김동현 on 10/26/25.
//

import UIKit

final class TodosSolveVC: UIViewController {
    
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
        view.backgroundColor = .systemBackground
        
        setupData()
        setupTableView()
        setupLayout()
    }
    
    private func setupData() {
        todoList = TodoSolve.getDumies()
    }
    
    private func setupTableView() {
        todoTableView.dataSource = self
        todoTableView.delegate = self
        todoTableView.register(
            TodoSolveCell.self,
            forCellReuseIdentifier: "TodoSolveCell"
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

extension TodosSolveVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TodoSolveCell = tableView.dequeueReusableCell(withIdentifier: "TodoSolveCell",
                                                                 for: indexPath) as? TodoSolveCell else {
            return UITableViewCell()
        }
        
        let cellData = todoList[indexPath.row]
        cell.configureCell(cellData: cellData)
        
        cell.isDoneChange = { [weak self] id, isDone in
            guard let self = self else { return }
            
            // todo.id와 클로저로 들어온 id
            if let foundIndex = todoList.firstIndex(where: { $0.id == id }) {
                self.todoList[foundIndex].isDone = isDone
                
                // 새로고침
                DispatchQueue.main.async {
                    tableView.reloadRows(at: [IndexPath(row: foundIndex, section: 0)], with: .fade)
                }
            }
        }
        return cell
    }
}

extension TodosSolveVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath
    ) {
        print()
    }
}
