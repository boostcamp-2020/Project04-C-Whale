//
//  TaskDetailCommentCell.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/09.
//

import UIKit

class TaskCommentCell: UICollectionViewListCell {
    
    var viewModel: TaskDetailModels.CommentVM? {
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
