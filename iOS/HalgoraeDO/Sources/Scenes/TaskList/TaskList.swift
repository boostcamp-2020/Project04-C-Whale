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
    
    func task(taskVM: TaskListModels.DisplayedTask, indexPath: IndexPath) -> Task? {
        guard 0..<sections.count ~= indexPath.section else { return nil }
        
        var superTasks = sections[indexPath.section].tasks
        if let parentPosition = taskVM.parentPosition,
           0..<(superTasks?.count ?? 0) ~= parentPosition {
            superTasks = superTasks?[parentPosition].tasks
        }
        guard 0..<(superTasks?.count ?? 0) ~= taskVM.position else { return nil }
        //TODO position 접근. -> task 접근
        return superTasks?[taskVM.position]
    }
    
    func task(identifier: String, postion: Int, parentPosition: Int?) -> Task? {
        
        var superTasks = tasks
        if let parentPosition = parentPosition  {
            superTasks = tasks[parentPosition].tasks ?? []
        }
        let isInRagne = 0..<superTasks.count ~= postion
        
        return isInRagne ? superTasks[postion] : nil
    }
}
