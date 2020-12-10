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
        
        contentConfiguration = content
    }
    
}
