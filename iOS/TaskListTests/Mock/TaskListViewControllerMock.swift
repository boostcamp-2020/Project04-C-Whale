//
//  TaskListViewControllerMock.swift
//  TaskListTests
//
//  Created by woong on 2020/12/17.
//

import UIKit

class TaskListViewControllerMock: TaskListDisplayLogic {
    
    func displayFetchTasks(viewModel: TaskListModels.FetchTasks.ViewModel) {
        
    }
    
    func displayFinishChanged(viewModel: TaskListModels.FinishTask.ViewModel) {
        
    }
    
    func displayFetchTasks(snapshot: NSDiffableDataSourceSectionSnapshot<TaskListModels.TaskVM>, sectionVM: TaskListModels.SectionVM, sectionVMs: [TaskListModels.SectionVM]) {
        
    }
    
    func displatFinishDragDrop(snapshot: NSDiffableDataSourceSectionSnapshot<TaskListModels.TaskVM>, sectionVM: TaskListModels.SectionVM) {
        
    }
}
