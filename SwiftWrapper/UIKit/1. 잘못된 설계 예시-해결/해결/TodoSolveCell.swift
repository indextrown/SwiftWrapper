//
//  TodoCell.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/14/25.
//

import UIKit

/*
 [정의] - 함수 자리를 만든다
 var isDoneChange: ((_ id: UUID, _ newValue: Bool) -> Void)? = nil
 - 함수를 담을 수 있는 변수를 정의한것
 - UUID랑 Bool을 받아서 실행되는 함수 하나를 저장할 수 있는 변수인데, 아직은 비어 있을 수도 있다
 - 이 셀에서 isDone이 바뀌면 바깥에서 정해진 함수(콜백)를 호출할 수 있게 하겠다
 
 [값 대입] - 자리에 함수를 넣는다
 cell.isDoneChange = { id, newValue in
     print("VC에서 처리:", id, newValue)
 }
 - 정의해둔 자리에 실제 함수를 넣어줌
 - 보통 ViewController에서
 
 [호출] - 자리에 들어 있는 함수를 실행한다
 isDoneChange?(id, sender.isOn)
 if let f = isDoneChange {
     f(id, sender.isOn)
 }
 - 만약 이 셀에 ‘isDone이 바뀌었을 때 실행할 함수’가 있다면, 지금 Todo의 id와 새 스위치 값으로 그 함수를 호출해라
 - Cell이 매개변수(id, newValue)를 외부로 전달하고, 외부(ViewController)에서 미리 만들어 둔 함수가 그 매개변수를 받아서 사용한다
 


 */

class TodoSolveCell: UITableViewCell {
    
    var cellData: TodoSolve? = nil
    var isDoneChange: ((_ id: UUID, _ newValue: Bool) -> Void)? = nil // uuid와 변경된 상태 전달
    
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
    
    let isDoneSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        isDoneSwitch.addTarget(self, action: #selector(handleIsDone), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print(#fileID, #function, #line, "- cellData.id: \(String(describing: cellData?.id.uuidString.prefix(8) ?? nil))")
    }
    
    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(isDoneSwitch)
        contentView.addSubview(titleLabel)
        contentView.addSubview(idLabel)
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
            
            // Switch (오른쪽)
            isDoneSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            isDoneSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    // MARK: - Configure
    func configureCell(cellData: TodoSolve) {
        // print(#fileID, #function, #line, "- cellData: \(cellData)")
        self.cellData = cellData
        titleLabel.text = cellData.title
        idLabel.text = String(cellData.id.uuidString.prefix(8))
        // isDoneSwitch.isOn = cellData.isDone
        isDoneSwitch.setOn(cellData.isDone, animated: false)
    }
    
    @objc func handleIsDone(_ sender: UISwitch) {
        print(#fileID, #function, #line, "- id: \(cellData?.id.uuidString ?? "") sender: \(sender.isOn)")
        guard let id = self.cellData?.id else { return }
        isDoneChange?(id, sender.isOn)
    }
}
