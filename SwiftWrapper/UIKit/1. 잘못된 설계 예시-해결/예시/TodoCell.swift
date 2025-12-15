//
//  TodoCell.swift
//  SwiftWrapper
//
//  Created by 김동현 on 12/14/25.
//

import UIKit

class TodoCell: UITableViewCell {
    
    var cellData: Todo? = nil
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let isDoneSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
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
    func configureCell(cellData: Todo) {
        // print(#fileID, #function, #line, "- cellData: \(cellData)")
        self.cellData = cellData
        titleLabel.text = cellData.title
        idLabel.text = String(cellData.id.uuidString.prefix(8))
        isDoneSwitch.isOn = cellData.isDone
    }
}
