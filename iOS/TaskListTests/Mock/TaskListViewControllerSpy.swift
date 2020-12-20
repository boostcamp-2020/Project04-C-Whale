//
//  TaskListViewControllerMock.swift
//  TaskListTests
//
//  Created by woong on 2020/12/17.
//

import UIKit

class TaskListViewControllerSpy: TaskListDisplayLogic {
    
    var displayFetchTasksViewModel: TaskListModels.FetchTasks.ViewModel?
    var displayFinishChangedViewModel: TaskListModels.FinishTask.ViewModel?
    var displayFinishDragDropViewModel: TaskListModels.DragDropTask.ViewModel?
    
    func displayFetchTasks(viewModel: TaskListModels.FetchTasks.ViewModel) {
        displayFetchTasksViewModel = viewModel
    }
    
    func displayFinishChanged(viewModel: TaskListModels.FinishTask.ViewModel) {
        displayFinishChangedViewModel = viewModel
    }
    
    func displayFinishDragDrop(viewModel: TaskListModels.DragDropTask.ViewModel) {
        displayFinishDragDropViewModel = viewModel
    }
}
