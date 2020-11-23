//
//  TaskListWorker.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import Foundation

class TaskListWorker {
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
}
