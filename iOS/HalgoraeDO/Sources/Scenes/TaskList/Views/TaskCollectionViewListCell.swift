//
//  TaskCollectionViewListCell.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

class TaskCollectionViewListCell: UICollectionViewListCell {
    
    var task: Task?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
        var taskContentConfiguration = TaskContentConfiguration().updated(for: state)
        taskContentConfiguration.title = task?.title
        taskContentConfiguration.isCompleted = task?.isCompleted
        
        contentConfiguration = taskContentConfiguration
    }
}
