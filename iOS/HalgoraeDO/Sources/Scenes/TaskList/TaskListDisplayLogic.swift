//
//  TaskListDisplayLogic.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/26.
//

import Foundation

protocol TaskListDisplayLogic {
    func display(tasks: [Task])
    func displayDetail(of task: Task)
    func set(editingMode: Bool)
    func display(numberOfSelectedTasks count: Int)
}
