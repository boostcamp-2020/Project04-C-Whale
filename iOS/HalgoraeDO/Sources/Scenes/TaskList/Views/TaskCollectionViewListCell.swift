//
//  TaskCollectionViewListCell.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

class TaskCollectionViewListCell: UICollectionViewListCell {
    
    weak var task: Task?
    var completeHandler: ((Task?) -> Void)?

    override func updateConfiguration(using state: UICellConfigurationState) {
        
        if state.isEditing {
            backgroundConfiguration?.backgroundColor = state.isSelected ? .lightGray : .clear
        } else {
            backgroundConfiguration?.backgroundColor = .clear
        }
        
        var taskContentConfiguration = TaskContentConfiguration().updated(for: state)
        taskContentConfiguration.title = task?.title
        taskContentConfiguration.isCompleted = task?.isCompleted
        
        contentConfiguration = taskContentConfiguration

        if let taskContentView = contentView as? TaskContentView {
            taskContentView.completeHandler = { [weak self] isCompleted in
                self?.task?.isCompleted = isCompleted
                self?.completeHandler?(self?.task)
            }
        }
        
    }
}
