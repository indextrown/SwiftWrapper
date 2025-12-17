//
//  RxDataSourceVC.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/15/25.
//

/**
멀티섹션
 - 데이터가 그룹으로 묶여져있다고 생각하면 된다
 - 지금까지는 싱글 섹션을 사용하고 있었다
 
 [형태]
 struct SectionOfCustomData {
   var header: String
   var items: [Item]
 }
 extension SectionOfCustomData: SectionModelType {
   typealias Item = CustomData

    init(original: SectionOfCustomData, items: [Item]) {
     self = original
     self.items = items
   }
 }
 
 let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(
   configureCell: { dataSource, tableView, indexPath, item in
     let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
     cell.textLabel?.text = "Item \(item.anInt): \(item.aString) - \(item.aCGPoint.x):\(item.aCGPoint.y)"
     return cell
 })
 
 dataSource.titleForHeaderInSection = { dataSource, index in
   return dataSource.sectionModels[index].header
 }

 dataSource.titleForFooterInSection = { dataSource, index in
   return dataSource.sectionModels[index].footer
 }

 dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
   return true
 }

 dataSource.canMoveRowAtIndexPath = { dataSource, indexPath in
   return true
 }
 */

import UIKit
import RxSwift
import RxDataSources
import RxCocoa

class RxDataSourceVCV4: UIViewController {
    
    /**
     Relay: subject개열인데 끊어지지 않는다.
     - 초기값이 필요하다
     - 초기깂이 있으므로 구독하는 순간 데이터가 들어온다
     - BehaviorRelay<[TodoSolve]>(value: [])
     - .value로 마지막 값을 가져올 수 있다 => Stateful하다
     */
    let todosRelay = BehaviorRelay<[RxTodoSolve]>(value: [])
    let disposeBag = DisposeBag()
    
    private lazy var todoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        return tableView
    }()
    
    private lazy var frontAddButton = UIBarButtonItem(title: "추가(앞)",
                                                 style: .plain,
                                                 target: nil,
                                                 action: nil)

    
    private lazy var backAddButton = UIBarButtonItem(title: "추가(뒤)",
                                                 style: .plain,
                                                 target: nil,
                                                 action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupData()
        setupTableView()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        title = "RxDataSource4"
        navigationItem.rightBarButtonItems = [backAddButton, frontAddButton]
    }
    
    private func setupData() {
        todosRelay.accept(RxTodoSolve.getDumies())
    }
    
    private func setupTableView() {
        todoTableView.register(RxTodoSolveCell.self, forCellReuseIdentifier: "RxTodoSolveCell")
        
        /// Observable, Subject계열은 데이터가 들어오면 새로 갱신하는 구조다(렌더링이 된다)
        /*
        todosRelay.bind(to: todoTableView.rx.items) { (tableView, row, element) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RxTodoSolveCell") as? RxTodoSolveCell else { return UITableViewCell() }
            cell.configureCell(cellData: element)
            
            // 삭제 버튼 구독
            cell.removeActionObservable
                .withUnretained(self)
                .debug("[Debug] - removeActionObservable")
                .map({ vc, uuid in
                    let currentTodos = vc.todosRelay.value
                    let filteredTodos = currentTodos.filter { $0.id != uuid }
                    return filteredTodos
                })
                .bind(onNext: { [weak self] filteredTodos in
                    self?.todosRelay.accept(filteredTodos)
                })
                .disposed(by: cell.disposeBag)
               
            // 토글 버튼 구독
            cell.updateActionObservable
                .debug("[Debug] - updateActionObservable")
                .bind(onNext: { [weak self] (id: UUID, updatedIsDone: Bool) in
                    guard let self = self else { return }
                    var currentTodos = self.todosRelay.value
                    if let foundTodoIndex = currentTodos.firstIndex(where: {$0.id == id}) {
                        currentTodos[foundTodoIndex].isDone = updatedIsDone
                        self.todosRelay.accept(currentTodos)
                    }

                })
                .disposed(by: cell.disposeBag)
            
            
            return cell
        }
        .disposed(by: disposeBag)
         */
        
        backAddButton.rx.tap
            .bind(onNext: { [weak self] _ in // ControlEvent<()> -> Void
                guard let self = self else { return }
                var currentTodos = self.todosRelay.value
                currentTodos.append(RxTodoSolve.getDummy())
                self.todosRelay.accept(currentTodos)
            })
            .disposed(by: disposeBag)
        
        frontAddButton.rx.tap
            .bind(onNext: { [weak self] _ in // ControlEvent<()> -> Void
                guard let self = self else { return }
                var currentTodos = self.todosRelay.value
                currentTodos.insert(RxTodoSolve.getDummy(), at: 0)
                self.todosRelay.accept(currentTodos)
            })
            .disposed(by: disposeBag)
        
        // MARK: - 멀티세션
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfTodo>(
          configureCell: { dataSource, tableView, indexPath, item in
              guard let cell = tableView.dequeueReusableCell(withIdentifier: "RxTodoSolveCell") as? RxTodoSolveCell else { return UITableViewCell() }
              cell.configureCell(cellData: item)
              
              // 삭제 버튼 구독
              cell.removeActionObservable
                  .withUnretained(self)
                  .debug("[Debug] - removeActionObservable")
                  .map({ vc, uuid in
                      let currentTodos = vc.todosRelay.value
                      let filteredTodos = currentTodos.filter { $0.id != uuid }
                      return filteredTodos
                  })
                  .bind(onNext: { [weak self] filteredTodos in
                      self?.todosRelay.accept(filteredTodos)
                  })
                  .disposed(by: cell.disposeBag)
                 
              // 토글 버튼 구독
              cell.updateActionObservable
                  .debug("[Debug] - updateActionObservable")
                  .bind(onNext: { [weak self] (id: UUID, updatedIsDone: Bool) in
                      guard let self = self else { return }
                      var currentTodos = self.todosRelay.value
                      if let foundTodoIndex = currentTodos.firstIndex(where: {$0.id == id}) {
                          currentTodos[foundTodoIndex].isDone = updatedIsDone
                          self.todosRelay.accept(currentTodos)
                      }

                  })
                  .disposed(by: cell.disposeBag)
              return cell
        },
          titleForHeaderInSection: { dataSource, sectionIndex -> String? in
              dataSource.sectionModels[sectionIndex].header
          },
          titleForFooterInSection: { dataSource, sectionIndex -> String? in
              dataSource.sectionModels[sectionIndex].footer
          }
        )
        
        let sections = [
            SectionOfTodo(header: "01: section", footer: "=== footer 01 ===", items: RxTodoSolve.getDumies(count: 2)),
            SectionOfTodo(header: "02: section", footer: "=== footer 02 ===", items: RxTodoSolve.getDumies(count: 3)),
            SectionOfTodo(header: "03: section", footer: "=== footer 03 ===", items: RxTodoSolve.getDumies(count: 4))
        ]
        
        Observable.just(sections)
            .bind(to: todoTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
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
