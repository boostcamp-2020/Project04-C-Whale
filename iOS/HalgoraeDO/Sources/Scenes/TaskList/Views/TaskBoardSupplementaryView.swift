//
//  TaskBoardSupplementaryView.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/12/01.
//

import UIKit

class TaskBoardSupplementaryView: UICollectionReusableView {
    
    var section: Int = 0
    
    // MARK: - Views
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.white.cgColor
        
        return view
    }()
    
    var sectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: CGFloat(20))
        
        return label
    }()
    
    var rowNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var moreButton: UIButton = {
        let moreImage = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium))
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(moreImage, for: .normal)
        button.tintColor = .gray
        
        return button
    }()
    
    var addTaskButton: UIButton = {
        let plusImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .bold, scale: .medium))
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(plusImage, for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.setTitle(" 작업 추가", for: .normal)
        button.tintColor = .halgoraedoDarkBlue
        
        return button
    }()
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Initialize
    
    func configureHeader(sectionName: String, rowNum: Int) {
        sectionLabel.text = sectionName
        rowNumberLabel.text = "\(rowNum)"

        addSubview(sectionLabel)
        addSubview(rowNumberLabel)
        addSubview(moreButton)
        
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
        addSubview(addTaskButton)
        addTaskButton.addTarget(self, action: #selector(priorityPopover), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addTaskButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            addTaskButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            addTaskButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    //MARK: - Helper Method
    
    @objc private func priorityPopover(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "displayAddTask"), object: section)
    }
}
