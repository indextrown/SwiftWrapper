//
//  TodoCell.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/14/25.
//

import UIKit
import RxSwift

class RxTodoSolveCell: UITableViewCell {
    
    var cellData: RxTodoSolve? = nil
    var disposeBag = DisposeBag()
    var removeActionObservable: Observable<UUID> = Observable.empty()
    var updateActionObservable: Observable<(id: UUID, newValue: Bool)> = Observable.empty( )
    
    // MARK: - UI
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let isDoneSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        
        // 삭제2) rx 방식
        removeActionObservable = removeButton.rx.tap
            .debug("[Debug] - removeActionObservable")
            .compactMap({ [weak self] _ in
                self?.cellData?.id
            })
        
        // 삭제2) rx반식
        updateActionObservable = isDoneSwitch.rx
            .controlEvent(.valueChanged)
            .debug("[Debug] - isDoneSwitch") // Observable<Bool>
            // input: Observable<Bool>
            // output: Observable<(id: UUID, newValue: Bool)>
            .compactMap ({ [weak self] _ -> (id: UUID, newValue: Bool)? in   // Bool → (UUID, Bool)?
                guard let self = self,
                        let unWrappedId = self.cellData?.id else { return nil }
                return (id: unWrappedId, newValue: self.isDoneSwitch.isOn)
            }) // Observable<(idL UUID, newValue: Bool)>
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // print(#fileID, #function, #line, "- cellData.id: \(String(describing: cellData?.id.uuidString.prefix(8) ?? nil))")
        
        // MARK: - 쓰레기를 비우는 과정
        self.disposeBag = DisposeBag()
    }
    
    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(isDoneSwitch)
        contentView.addSubview(titleLabel)
        contentView.addSubview(idLabel)
        contentView.addSubview(removeButton)
        contentView.addSubview(isDoneSwitch)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            
            // Title Label
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: isDoneSwitch.leadingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),

            // ID Label
            idLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            idLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            idLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            idLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            // RemoveButton
            removeButton.trailingAnchor.constraint(equalTo: isDoneSwitch.leadingAnchor, constant: -12),
            removeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Switch (오른쪽)
            isDoneSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            isDoneSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    // MARK: - Configure
    func configureCell(cellData: RxTodoSolve) {
        // print(#fileID, #function, #line, "- cellData: \(cellData)")
        self.cellData = cellData
        titleLabel.text = cellData.title
        idLabel.text = String(cellData.id.uuidString.prefix(8))
        // isDoneSwitch.isOn = cellData.isDone
        isDoneSwitch.setOn(cellData.isDone, animated: false)
    }
}
