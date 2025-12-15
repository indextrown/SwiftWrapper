//
//  RxDataSourceVC.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/15/25.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa

class RxDataSourceVC: UIViewController {
    
    // var todoList: Observable<[TodoSolve]> = Observable<[TodoSolve]>.empty()
    let todoList = BehaviorRelay<[TodoSolve]>(value: [])

    var disposeBag = DisposeBag()
    
    private lazy var todoTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        setupData()
        setupTableView()
        setupLayout()
    }
    
    private func setupData() {
        // todoList = Observable<[TodoSolve]>.just(TodoSolve.getDumies())
        todoList.accept(TodoSolve.getDumies())
    }
    
    private func setupTableView() {
        todoTableView.register(TodoSolveCell.self, forCellReuseIdentifier: "TodoSolveCell")
        
        /*
         1번 방식
         - RxCocoa가 UITableViewDataSource를 자동으로 만들어줌
         - dequeueReusableCell 자동 처리
         - 타입 안전 (cell이 TodoSolveCell로 보장됨)
         - 코드가 짧고 명확
         - cell 생성 로직 커스터마이징 한계
         - cellIdentifier 고정
         - cellIdentifier 고정
         - 셀 타입이 1개
         - 일반적인 리스트 화면
         - CRUD / 목록 / 설정 화면
        todoList.bind(to: todoTableView.rx.items(cellIdentifier: "TodoSolveCell", cellType: TodoSolveCell.self)) { [weak self] index, model, cell in
            guard let self = self else { return }
            
            cell.configureCell(cellData: model)

            cell.isDoneChange = { id, isDone in
                var list = self.todoList.value
                list[index].isDone = isDone
                
                self.todoList.accept(list)
            }
            
            /*
            cell.isDoneChange = { id, isDone in
                var list = self.todoList.value
                list[index].isDone = isDone
                
                Observable.just(list)
                    .observe(on: MainScheduler.asyncInstance)
                    .bind(to: self.todoList)
                    .disposed(by: self.disposeBag)
            }
             */
        }
         
         */
        
        
        /*
         2번 방식
         ✔️ 이 방식의 특징
         - 셀 생성 로직을 전부 직접 제어
         - 여러 cell 타입 분기 가능
         - IndexPath 직접 다룸
         - legacy UIKit 스타일에 가까움
         ❌ 단점
         - 타입 캐스팅 필요
         - 코드 길어짐
         - 실수 여지 많음
         ✅ 언제 쓰냐
         - 여러 종류의 셀을 섞어야 할 때
         - section / row에 따라 셀 타입 다를 때
         - custom cell factory가 필요할 때
         */
        todoList.bind(to: todoTableView.rx.items) { (tableView, row, element) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoSolveCell") as? TodoSolveCell else { return UITableViewCell() }
            cell.configureCell(cellData: element)
            return cell
        }
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
