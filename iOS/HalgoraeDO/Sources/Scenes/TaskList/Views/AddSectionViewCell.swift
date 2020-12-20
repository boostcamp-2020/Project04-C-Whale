//
//  AddSectionViewCell.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/12/01.
//
import UIKit

class AddSectionViewCell: UICollectionViewCell {
    
    var addSectionButton: UIButton = {
        let addSectionImage = UIImage(systemName: "rectangle.badge.plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .light, scale: .small))
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(addSectionImage, for: .normal)
        button.setTitle(" 섹션 추가", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 6, bottom: 10, right: 6)
        button.addTarget(self, action: #selector(tabAddSection), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Initialize
    
    func configCollectionViewCell() {
        contentView.addSubview(addSectionButton)
        addSectionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addSectionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            addSectionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            addSectionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
        ])
    }
    
    //MARK: - Helper Method
    
    @objc private func tabAddSection(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "addSection"), object: self)
    }
}

