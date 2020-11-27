//
//  TaskCollectionViewListCell.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

class TaskCollectionViewListCell: UICollectionViewListCell {
    
    var taskViewModel: TaskListModels.TaskViewModel?
    var finishHandler: ((TaskListModels.TaskViewModel?) -> Void)?

    override func updateConfiguration(using state: UICellConfigurationState) {
        
        backgroundConfiguration?.backgroundColor = (state.isSelected || state.isHighlighted) ? .lightGray : .white
        
        var taskContentConfiguration = TaskContentConfiguration().updated(for: state)
        taskContentConfiguration.title = taskViewModel?.title
        taskContentConfiguration.isCompleted = taskViewModel?.isCompleted
        
        contentConfiguration = taskContentConfiguration

        if let taskContentView = contentView as? TaskContentView {
            taskContentView.completeHandler = { [weak self] isCompleted in
                self?.taskViewModel?.isCompleted = isCompleted
                self?.finishHandler?(self?.taskViewModel)
            }
        }
    }
}
