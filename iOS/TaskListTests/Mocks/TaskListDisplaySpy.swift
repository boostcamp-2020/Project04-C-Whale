//
//  TaskListSpy.swift
//  TaskListTests
//
//  Created by woong on 2020/11/26.
//

import Foundation

class TaskListDisplaySpy: TaskListDisplayLogic {
    
    var displayTasks = false
    var displayDetail = false
    var setEditingMode = false
    var displayNumberOfSelectedTasks = false
    
    func display(tasks: [TaskListModels.TaskViewModel]) {
        displayTasks = true
    }
    
    func displayDetail(of task: Task) {
        displayDetail = true
    }
    
    func set(editingMode: Bool) {
        setEditingMode = true
    }
    
    func display(numberOfSelectedTasks count: Int) {
        displayNumberOfSelectedTasks = true
    }
}
