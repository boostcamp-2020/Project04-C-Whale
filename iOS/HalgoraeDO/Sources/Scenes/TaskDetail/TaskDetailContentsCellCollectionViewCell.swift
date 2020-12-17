//
//  TaskDetailContentsCellCollectionViewCell.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/10.
//

import UIKit

class TaskDetailContentsCellCollectionViewCell: UICollectionViewListCell {
    
    var viewModel: TaskDetailModels.ContentsVM? {
        didSet {
            updateConfiguration(using: .init(traitCollection: .current))
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var content = defaultContentConfiguration()
        content.text = viewModel?.contents
        content.image = viewModel?.image
        content.imageProperties.tintColor = .halgoraedoDarkBlue
        
        var background = UIBackgroundConfiguration.listPlainCell()
        background.cornerRadius = 8
        background.strokeColor = .systemGray3
        backgroundConfiguration = background
        shadow()
        contentConfiguration = content
    }
    
}
