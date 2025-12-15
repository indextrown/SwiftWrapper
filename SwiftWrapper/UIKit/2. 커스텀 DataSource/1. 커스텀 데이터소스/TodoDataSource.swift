//
//  TodoDataSource.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/15/25.
//

import UIKit

class TodoDataSource: NSObject, UITableViewDataSource {
    var todoList: [TodoSolve] = []
    var tableView: UITableView? = nil
    
    init(todoList: [TodoSolve], tableView: UITableView) {
        self.todoList = todoList
        self.tableView = tableView
    }
}

// MARK: - UITableView Datasource Method
extension TodoDataSource {
    // 하나의 섹션에 `몇개`를 보여줄 것인가
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.count
    }
    
    // `어떤셀을` 보여줄 것인가
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


// MARK: - Register
extension TodoDataSource {
    func register(cellClass: AnyClass, forCellReuseIdentifier: String) {
        tableView?.register(cellClass, forCellReuseIdentifier: forCellReuseIdentifier)
    }
}
