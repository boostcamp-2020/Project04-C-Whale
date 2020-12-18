//
//  TaskListInteractorMock.swift
//  TaskListTests
//
//  Created by woong on 2020/12/17.
//

import Foundation

class TaskListInteractorSpy: TaskListBusinessLogic {
    
    var ftchTasksRequest: TaskListModels.FetchTasks.Request?
    var fetchTasksForCompleteRequest: TaskListModels.FetchTasks.Request?
    var updateCompleteRequest: TaskListModels.FinishTask.Request?
    var updateCompleteAllRequest: TaskListModels.FinishTask.Request?
    var createTaskRequest: TaskListModels.CreateTask.Request?
    var createSectionRequest: TaskListModels.CreateSection.Request?
    var fetchDragDropRequest: TaskListModels.MoveTask.Request?
    var dragDropForListRequest: TaskListModels.DragDropTask.RequestForList?
    var dragDropForBoardRequest: TaskListModels.DragDropTask.RequestForBoard?
    
    func fetchTasks(request: TaskListModels.FetchTasks.Request) {
        fetchTasksForCompleteRequest = request
    }
    
    func fetchTasksForComplete(request: TaskListModels.FetchTasks.Request) {
        fetchTasksForCompleteRequest = request
    }
    
    func updateComplete(request: TaskListModels.FinishTask.Request) {
        updateCompleteRequest = request
    }
    
    func updateCompleteAll(request: TaskListModels.FinishTask.Request, projectId: String) {
        updateCompleteAllRequest = request
    }
    
    func createTask(request: TaskListModels.CreateTask.Request) {
        createTaskRequest = request
    }
    
    func createSection(request: TaskListModels.CreateSection.Request) {
        createSectionRequest = request
    }
    
    func fetchDragDrop(request: TaskListModels.MoveTask.Request) {
        fetchDragDropRequest = request
    }
    
    func dragDropForList(requset: TaskListModels.DragDropTask.RequestForList) {
        dragDropForListRequest = requset
    }
    
    func dragDropForBoard(requset: TaskListModels.DragDropTask.RequestForBoard) {
        dragDropForBoardRequest = requset
    }
}
