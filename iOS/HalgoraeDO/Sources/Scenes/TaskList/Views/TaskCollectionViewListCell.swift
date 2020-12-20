//
//  TaskCollectionViewListCell.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

class TaskCollectionViewListCell: UICollectionViewListCell {
    
    // MARK:  - Properties
    
    var taskViewModel: TaskListModels.TaskVM? {
        didSet {
            updateConfiguration(using: .init(traitCollection: .current))
        }
    }
    var doneHandler: ((TaskCollectionViewListCell?, TaskListModels.TaskVM) -> Void)?
    
    // MARK: - Methods

    override func updateConfiguration(using state: UICellConfigurationState) {
        backgroundConfiguration?.backgroundColor = (state.isSelected || state.isHighlighted) ? .lightGray : .white

        var taskContentConfiguration = TaskContentConfiguration().updated(for: state)
        taskContentConfiguration.configure(viewModel: taskViewModel)
        contentConfiguration = taskContentConfiguration
        
        if let taskContentView = contentView as? TaskContentView {
            taskContentView.completeHandler = { [weak self] isCompleted in
                self?.taskViewModel?.isCompleted = isCompleted
                guard let viewModel = self?.taskViewModel else { return }
                self?.doneHandler?(self, viewModel)
            }
        }
    }
}
