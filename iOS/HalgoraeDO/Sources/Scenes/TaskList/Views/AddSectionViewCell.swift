//
//  AddSectionViewCell.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/12/01.
//
import UIKit

class AddSectionViewCell: UICollectionViewCell {
    
    func configCollectionViewCell() {
        let addSectionButton: UIButton = UIButton()
        let addSectionImage = UIImage(systemName: "rectangle.badge.plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .light, scale: .small))
        addSectionButton.setImage(addSectionImage, for: .normal)
        addSectionButton.setTitle(" 섹션 추가", for: .normal)
        addSectionButton.setTitleColor(.black, for: .normal)
        addSectionButton.tintColor = .black
        addSectionButton.backgroundColor = .systemGray5
        addSectionButton.layer.cornerRadius = 10
        addSectionButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 6, bottom: 10, right: 6)
        
        self.contentView.addSubview(addSectionButton)
        addSectionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addSectionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            addSectionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            addSectionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
        ])
    }
    
}

