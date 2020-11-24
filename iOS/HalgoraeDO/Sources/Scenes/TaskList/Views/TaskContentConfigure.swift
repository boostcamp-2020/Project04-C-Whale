//
//  TaskContentConfigure.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/24.
//

import UIKit

struct TaskContentConfiguration: UIContentConfiguration, Hashable {
    
    var title: String?
    var image: UIImage?
    var isCompleted: Bool?
    
    func makeContentView() -> UIView & UIContentView {
        return TaskContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        guard let state = state as? UICellConfigurationState else {
            return self
        }
        
        var updatedConfiguration = self
        
        return updatedConfiguration
    }
    
}
