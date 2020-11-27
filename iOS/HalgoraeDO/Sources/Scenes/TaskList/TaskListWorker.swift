//
//  TaskListWorker.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import Foundation

class TaskListWorker {
    private(set) var selectedTasks = Set<TaskListModels.TaskViewModel>()
    var isEditingMode = false {
        didSet {
            guard isEditingMode else {
                selectedTasks.removeAll()
                return
            }
        }
    }
    
    func getTasks() -> [Task] {
        return [
            Task(title: "할고래두", subTasks: [
                    Task(title: "hihi"),
                    Task(title: "hihi2"),
                    Task(title: "hehehe3"),
                ]),
            Task(title: "당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지당연하지"),
            Task(title: "두 말하면 섭함"),
        ]
    }
    
    func append(selected task: TaskListModels.TaskViewModel) {
        selectedTasks.insert(task)
    }
    
    func remove(selected task: TaskListModels.TaskViewModel) {
        selectedTasks.remove(task)
    }
}
