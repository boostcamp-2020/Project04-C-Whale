//
//  TaskContentConfigure.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/24.
//

import UIKit

protocol TaskContentViewModelType {
    var title: String { get }
    var tintColor: UIColor { get }
    var isCompleted: Bool { get set }
}

struct TaskContentConfiguration: UIContentConfiguration, Hashable {
    
    // MARK: - Properties
    
    private(set) var title: String?
    private(set) var image: UIImage?
    private(set) var tintColor: UIColor?
    private(set) var isCompleted: Bool?
    private(set) var isEditing = false
    
    // MARK: - Methods
    
    mutating func configure(viewModel: TaskContentViewModelType?) {
        title = viewModel?.title
        isCompleted = viewModel?.isCompleted
        tintColor = viewModel?.tintColor
    }
    
    func makeContentView() -> UIView & UIContentView {
        return TaskContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        guard let state = state as? UICellConfigurationState else { return self }
        var updatedConfiguration = self
        updatedConfiguration.title = title
        updatedConfiguration.isCompleted = isCompleted
        updatedConfiguration.isEditing = state.isEditing
        
        return updatedConfiguration
    }
}
