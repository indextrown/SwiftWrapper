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

class RxDataSourceVCV5: UIViewController {
    
    /**
     Relay: subject개열인데 끊어지지 않는다.
     - 초기값이 필요하다
     - 초기깂이 있으므로 구독하는 순간 데이터가 들어온다
     - BehaviorRelay<[TodoSolve]>(value: [])
     - .value로 마지막 값을 가져올 수 있다 => Stateful하다
     */
    let todosRelay = BehaviorRelay<[RxTodoSolve]>(value: [])
    let sectionsRelay = BehaviorRelay<[SectionOfTodo]>(value: [])
    let disposeBag = DisposeBag()
    
    let sections = [
        SectionOfTodo(header: "01: section", footer: "=== footer 01 ===", items: RxTodoSolve.getDumies(count: 2)),
        SectionOfTodo(header: "02: section", footer: "=== footer 02 ===", items: RxTodoSolve.getDumies(count: 3)),
        SectionOfTodo(header: "03: section", footer: "=== footer 03 ===", items: RxTodoSolve.getDumies(count: 20))
    ]
    
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
        
        setupHeaderFooterView()
        setupNavigationBar()
        setupData()
        setupTableView()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        title = "RxDataSource5"
        navigationItem.rightBarButtonItems = [backAddButton, frontAddButton]
    }
    
    private func setupData() {
        todosRelay.accept(RxTodoSolve.getDumies())
    }
    
    private func setupTableView() {
        todoTableView.register(RxTodoSolveCell.self, forCellReuseIdentifier: "RxTodoSolveCell")
        
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
                var currentTodoSections = self.sectionsRelay.value
                
                currentTodoSections[0].items.insert(RxTodoSolve(), at: 0)
                self.sectionsRelay.accept(currentTodoSections)
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
//                  .map({ vc, uuid in
//                      let currentTodos = vc.todosRelay.value
//                      let filteredTodos = currentTodos.filter { $0.id != uuid }
//                      return filteredTodos
//                  })
                  .map({ vc, uuid in
                      let currentSections: [SectionOfTodo] = vc.sectionsRelay.value
                      
                      let updatedSections: [SectionOfTodo] = currentSections.map ({ aSection in // let
                          var updatedSection: SectionOfTodo = aSection
                          let updaedItems: [RxTodoSolve] = aSection.items.filter { $0.id != uuid }
                          
                          updatedSection.items = updaedItems
                          return updatedSection
                      })
                      return updatedSections
                  })
                  .bind(onNext: { [weak self] filteredTodos in
                      self?.sectionsRelay.accept(filteredTodos)
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
//          titleForHeaderInSection: { dataSource, sectionIndex -> String? in
//              dataSource.sectionModels[sectionIndex].header
//          },
//          titleForFooterInSection: { dataSource, sectionIndex -> String? in
//              dataSource.sectionModels[sectionIndex].footer
//          }
        )
        
       
        sectionsRelay.accept(sections)
        
        sectionsRelay
            .bind(to: todoTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupHeaderFooterView() {
        todoTableView.register(CustomHeaderView.self,
                               forHeaderFooterViewReuseIdentifier: CustomHeaderView.identifier)
        
        todoTableView.register(CustomFooterView.self,
                               forHeaderFooterViewReuseIdentifier: CustomFooterView.identifier
        )
        
        todoTableView.rx.setDelegate(self)
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

extension RxDataSourceVCV5: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as? CustomHeaderView
        // let sectionData = "\(section + 1) 번째 섹션이다."
        headerView?.configure(title: sectionsRelay.value[section].header)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: CustomFooterView.identifier
        ) as? CustomFooterView
        
        footerView?.configure(title: sectionsRelay.value[section].footer)
        return footerView
    }
}
