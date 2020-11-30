//
//  TaskCollectionViewListCell.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

class TaskCollectionViewListCell: UICollectionViewListCell {
    
    weak var task: Task?
    var finishHandler: ((Task?) -> Void)?

    override func updateConfiguration(using state: UICellConfigurationState) {
        
        backgroundConfiguration?.backgroundColor = (state.isSelected || state.isHighlighted) ? .lightGray : .white
        
        var taskContentConfiguration = TaskContentConfiguration().updated(for: state)
        taskContentConfiguration.title = task?.title
        taskContentConfiguration.isCompleted = task?.isCompleted
        
        contentConfiguration = taskContentConfiguration

        if let taskContentView = contentView as? TaskContentView {
            taskContentView.completeHandler = { [weak self] isCompleted in
                self?.task?.isCompleted = isCompleted
                self?.finishHandler?(self?.task)
            }
        }
    }
}
