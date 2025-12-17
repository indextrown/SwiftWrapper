//
//  RxDataSourceVC.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/15/25.
//

/**
 [CRUD]
 
 subscribe(onNext:) - 가장 원시적인 이벤트 처리
 bind(onNext:)         - 에러 없는 subscribe
 bind(to:)                 - UI에 안전하게 연결
 
 1.  subscribe(onNext:)
 observable.subscribe(onNext: { value in
     // 이벤트 직접 처리
 })
 -> 값이 오면 내가 직접 처리하겠다
 -> onNext / onError / onCompleted 전부 처리 가능
 -> 안전 보장 ❌
 
 
 2.   bind(onNext:)
 observable.bind(onNext: { value in
     // 에러 없는 이벤트 처리
 })
 -> 값만 필요하고, 에러는 신경 안 쓸게
 -> 사실상 subscribe의 안전 버전
 -> `onError` 없음
 -> 에러 발생 시 자동 무시
 -> 메인 스레드 보장 ❌
 
 
 3.  bind(to:)
 observable.bind(to: label.rx.text)
 -> 이 스트림을 UI에 안전하게 연결하겠다
 -> UI 전용
 ->`Binder` 기반
 -> 항상 MainScheduler
 -> 에러 발생 ❌ (자동 무시)
 
 
 Observable 종류
 1.  Cold Observable(구독해야 시작됨)
 2.  Hot Observable(이미 돌아가고 있음
 
 Share
 - Cold Observable을 Hot처럼 만들어주는 연산자
 ex)
 let observable = Observable<Int>.create {
     print("API 요청")
     return Disposables.create()
 }.share()

 
 [정리]
 Cold Observable는 "구독자가 실행 시킨다"
 share는 첫 번째 구독자가 실행을 시작시키고 스트림이 살아 있는 동안에만 다음 구독자가 참여할 수 있다
 -> share는 실행을 재사용하는게 아니라 실행을 공유한다
 
 [Share]
 share(replay: 1)
 - 첫 구독자가 실행을 시작하고 실행 결과 1개를 저장해서 나중에 오는 구독자에게도 실행한다
 - 같은 실행을 여러 구독자가 같이 써야 할 때
 - 같은 실행을 여러 구독자가 같이 써야 할 때
 - .share()는 “cold observable이 부작용(side-effect)을 가질 때” 쓴다 UI 이벤트 / Relay에는 쓰지 않는다
 - 여러 곳에서 같은 작업 결과(API 요청등)을 공유해야 할 떄 Cold Observable을 Hot Observable로 변경한다
 
 [테이블뷰는 메모리를 재활용해서 무한구독이 안되는 장점!!]
 */

import UIKit
import RxSwift
import RxDataSources
import RxCocoa

class RxDataSourceVCV3: UIViewController {
    
    /**
     Relay: subject개열인데 끊어지지 않는다.
     - 초기값이 필요하다
     - 초기깂이 있으므로 구독하는 순간 데이터가 들어온다
     - BehaviorRelay<[TodoSolve]>(value: [])
     - .value로 마지막 값을 가져올 수 있다 => Stateful하다
     */
    let todosRelay = BehaviorRelay<[RxTodo]>(value: [])
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
        title = "RxDataSource3"
        navigationItem.rightBarButtonItems = [backAddButton, frontAddButton]
    }
    
    private func setupData() {
        todosRelay.accept(RxTodo.getDumies())
    }
    
    private func setupTableView() {
        todoTableView.register(RxTodoCell.self, forCellReuseIdentifier: "RxTodoCell")
        
        /// Observable, Subject계열은 데이터가 들어오면 새로 갱신하는 구조다(렌더링이 된다)
        todosRelay.bind(to: todoTableView.rx.items) { (tableView, row, element) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RxTodoCell") as? RxTodoCell else { return UITableViewCell() }
            cell.configureCell(cellData: element)
            
            // 삭제 버튼1)
            /*
            cell.removeAction = { id in
                let currentTodos = self.todosRelay.value
                let filteredTodos = currentTodos.filter({ $0.id != id })
                self.todosRelay.accept(filteredTodos)
            }
             
             // 토글 버튼
             cell.isDoneChange = { id, newValue in
                 var currentTodos = self.todosRelay.value
                 if let foundTodoIndex = currentTodos.firstIndex(where: {$0.id == id}) {
                     currentTodos[foundTodoIndex].isDone = newValue
                     self.todosRelay.accept(currentTodos)
                 }
             }
             */
            
            /**
             .disposed(by: self.disposeBag)
             - 치명적 버그: 구독을 계속해서 메모리 올라감
             
             Cell이 가진 Dispose로 해야한다
             -  .disposed(by: cell.disposeBag)
             
             Rx기반으로 작업을 하려면 테이블뷰나 컬렉션뷰는 메모리 재활용해야한다
             - .disposed(by: cell.disposeBag)
             - cell에 가서 아래코드추가
             override func prepareForReuse() {
                 super.prepareForReuse()
             
                 // MARK: - 쓰레기를 비우는 과정
                 self.disposeBag = DisposeBag()
             }
             */
            
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
        
        /// 몇초뒤 데이터를 추가(Rx 스타일)
        /*
        Observable.just(())
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .map { RxTodo.getDumies(count: 3) } // Ovservable<[TodoSolve]> 형태 변경 가능(선택적)
            .bind(onNext: {
                self.todosRelay.accept($0)
            })
            .disposed(by: disposeBag)
         */
        
        /// 몇초뒤 데이터를 추가(기본 스타일)
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.todosRelay.accept(TodoSolve.getDumies(count: 3))
        }
         */
        
        /**
         addButton.rx.tap
         - ControlEvent<()> -> RxCocoa에서 만든 UI이벤트 전용 Observable래퍼
         - 메인스레드 보장
         - 에러 발생 X
         - complete 없음
         - share: 여러 구독자가 있어도 하나의 이벤트 소스를 공유한다
         */
        backAddButton.rx.tap
            .bind(onNext: { [weak self] _ in // ControlEvent<()> -> Void
                guard let self = self else { return }
                var currentTodos = self.todosRelay.value
                currentTodos.append(RxTodo.getDummy())
                self.todosRelay.accept(currentTodos)
            })
            .disposed(by: disposeBag)
        
        frontAddButton.rx.tap
            .bind(onNext: { [weak self] _ in // ControlEvent<()> -> Void
                guard let self = self else { return }
                var currentTodos = self.todosRelay.value
                currentTodos.insert(RxTodo.getDummy(), at: 0)
                self.todosRelay.accept(currentTodos)
            })
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
