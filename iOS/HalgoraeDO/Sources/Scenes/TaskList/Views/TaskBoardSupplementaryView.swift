//
//  TaskBoardSupplementaryView.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/12/01.
//

import UIKit

class TaskBoardSupplementaryView: UICollectionReusableView {
    
    var section: Int = 0
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = UIView()
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        layer.backgroundColor = UIColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Initialize
    
    func configureHeader(sectionName: String, rowNum: Int) {
        let sectionLabel = UILabel()
        let rowNumberLabel = UILabel()
        let moreButton = UIButton()
        let moreImage = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium))
        
        addSubview(sectionLabel)
        addSubview(rowNumberLabel)
        addSubview(moreButton)
        moreButton.setImage(moreImage, for: .normal)
        moreButton.tintColor = .gray
        sectionLabel.text = sectionName
        sectionLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(20))
        rowNumberLabel.text = "\(rowNum)"
        
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        rowNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sectionLabel.trailingAnchor.constraint(equalTo: rowNumberLabel.leadingAnchor, constant: 20),
            sectionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            rowNumberLabel.widthAnchor.constraint(equalToConstant: 50),
            rowNumberLabel.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: 20),
            rowNumberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            moreButton.widthAnchor.constraint(equalToConstant: 50),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            moreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])
    }
    
    func configureFooter() {
        let addTaskButton = UIButton()
        let plusImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .bold, scale: .medium))
        addSubview(addTaskButton)
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.setImage(plusImage, for: .normal)
        addTaskButton.setTitleColor(.systemGray, for: .normal)
        addTaskButton.setTitle(" 작업 추가", for: .normal)
        addTaskButton.tintColor = .red
        addTaskButton.addTarget(self, action: #selector(priorityPopover), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addTaskButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            addTaskButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            addTaskButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    //MARK: - Helper Method
    
    @objc private func priorityPopover(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "displayAddTask"), object: section)
        #if DEBUG
        print("작업 추가 TODO")
        #endif
    }
    
}
