//
//  TaskListPresenterMock.swift
//  TaskListTests
//
//  Created by woong on 2020/12/17.
//

import Foundation

class TaskListPresenterSpy: TaskListPresentLogic {

    var presentFetchTasksResponse: TaskListModels.FetchTasks.Response?
    var presentFetchTasksForAllResponse: TaskListModels.FetchTasks.Response?
    var presentFinshChangedResponse: TaskListModels.FinishTask.Response?
    var presentFinishDragDropResponse: TaskListModels.DragDropTask.Response?
    
    func presentFetchTasks(response: TaskListModels.FetchTasks.Response) {
        presentFetchTasksResponse = response
    }
    
    func presentFetchTasksForAll(response: TaskListModels.FetchTasks.Response) {
        presentFetchTasksForAllResponse = response
    }
    
    func presentFinshChanged(response: TaskListModels.FinishTask.Response) {
        presentFinshChangedResponse = response
    }
    
    func presentFinishDragDrop(response: TaskListModels.DragDropTask.Response) {
        presentFinishDragDropResponse = response
    }
}
