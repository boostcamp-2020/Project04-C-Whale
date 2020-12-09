//
//  TaskListManager.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/30.
//

import Foundation

class TaskList {
    
    var sections: [Section] = []
    var tasks: [Task] = []
    
    func task(identifier: String, postion: Int, parentPosition: Int?) -> Task? {
        var superTasks = tasks
        if let parentPosition = parentPosition  {
            superTasks = tasks[parentPosition].tasks ?? []
        }
        let isInRagne = 0..<superTasks.count ~= postion
        
        return isInRagne ? superTasks[postion] : nil
    }
}
