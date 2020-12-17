//
//  TaskListInteractorMock.swift
//  TaskListTests
//
//  Created by woong on 2020/12/17.
//

import Foundation

class TaskListInteractorMock: TaskListBusinessLogic {
    
    func fetchTasks(request: TaskListModels.FetchTasks.Request) {
        
    }
    
    func fetchTasksForComplete(request: TaskListModels.FetchTasks.Request) {
        
    }
    
    func fetchDragDrop(request: TaskListModels.MoveTask.Request) {
        
    }
    
    func changeFinish(request: TaskListModels.FinishTask.Request) {
        
    }
    
    func changeFinishForAll(request: TaskListModels.FinishTask.Request, projectId: String) {
        
    }
    
    func createTask(request: TaskListModels.CreateTask.Request) {
        
    }
    
    func createSection(request: TaskListModels.CreateSection.Request) {
        
    }
}
