//
//  TodoDataSource.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/15/25.
//

/*
셀에 대한 로직을 외부로 빼고 싶을 때 해결법
 - 외부에서 Cell을 클로저 매개변수로 받아서 자유롭게 만들도록 하자
 */

import UIKit

class TodoDataSourceV4: NSObject, UITableViewDataSource {
    var todoList: [TodoSolve] = []
    var tableView: UITableView? = nil
    var configureCell: ((TodoDataSourceV4, UITableView, Int, TodoSolve, TodoSolveCell) -> Void)? = nil // 클로저를 담는 변수
    var cellId: String = ""
    
    init(todoList: [TodoSolve], tableView: UITableView) {
        self.todoList = todoList
        self.tableView = tableView
    }
}

// MARK: - UITableView Datasource Method
extension TodoDataSourceV4 {
    // 하나의 섹션에 `몇개`를 보여줄 것인가
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.count
    }
    
    // `어떤셀을` 보여줄 것인가
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = todoList[indexPath.row]
        
        let cell: TodoSolveCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TodoSolveCell
        
        // MARK: - 고정된 로직을 클로저를 통해 외부로 뺀다
        // 셀을 만드는 로직 -> 매개변수로 만들자(클로저 = 로직->변수)
        configureCell?(self, tableView, indexPath.row, cellData, cell)
        return cell
    }
}


// MARK: - Register
extension TodoDataSourceV4 {
    func register(cellClass: AnyClass, forCellReuseIdentifier: String) {
        tableView?.register(cellClass, forCellReuseIdentifier: forCellReuseIdentifier)
        self.cellId = forCellReuseIdentifier
    }
}

// MARK: - Update
extension TodoDataSourceV4 {
    func setData(newValue: [TodoSolve]) {
        self.todoList = newValue
        self.tableView?.reloadData()
    }
}
