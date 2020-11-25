//
//  TaskListPresenterSpy.swift
//  TaskListTests
//
//  Created by woong on 2020/11/26.
//

import Foundation

class TaskListPresenterSpy: TaskListPresentLogic {
    
    var presentTasks = false
    var setEditingMode = false
    var presentDetail_task: Task?
    var presentNumberOfSelectedTasks = -1
    
    func present(tasks: [Task]) {
        presentTasks = true
    }
    
    func set(editingMode: Bool) {
        setEditingMode = true
    }
    
    func presentDetail(of task: Task) {
        presentDetail_task = task
    }
    
    func present(numberOfSelectedTasks count: Int) {
        presentNumberOfSelectedTasks = count
    }
}
