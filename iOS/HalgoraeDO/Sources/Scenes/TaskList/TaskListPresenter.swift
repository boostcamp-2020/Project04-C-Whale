//
//  TaskListPresenter.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

protocol TaskListPresentLogic {
    func presentFetchTasks(response: TaskListModels.FetchTasks.Response)
    func presentFetchTasksForAll(response: TaskListModels.FetchTasks.Response)
    func presentFinshChanged(response: TaskListModels.FinishTask.Response)
    func presentFinishDragDrop(viewModel: TaskListModels.DragDropTask.ViewModel) 
}

class TaskListPresenter {
    
    // MARK:  - Constants
    
    typealias TaskVM = TaskListModels.TaskVM
    
    var viewController: TaskListDisplayLogic
    
    init(viewController: TaskListDisplayLogic) {
        self.viewController = viewController
    }
}

extension TaskListPresenter: TaskListPresentLogic {
    
    func presentFetchTasks(response: TaskListModels.FetchTasks.Response) {
        let sectionVMs = response.sections.compactMap { TaskListModels.SectionVM(section: $0) }
        var tempSectionVM: [TaskListModels.SectionVM] = []
        sectionVMs.forEach { section in
            var tempSection = section
            tempSection.tasks = section.tasks.filter( {$0.isCompleted == false} )
            tempSectionVM.append(tempSection)
        }
    
        for sectionVM in tempSectionVM {
            let sectionSnapshot = self.generateSnapshot(taskItems: sectionVM.tasks)
            viewController.displayFetchTasks(snapshot: sectionSnapshot, sectionVM: sectionVM, sectionVMs: tempSectionVM)
        }
    }
    
    func presentFetchTasksForAll(response: TaskListModels.FetchTasks.Response) {
        let sectionVMs = response.sections.compactMap { TaskListModels.SectionVM(section: $0) }
        for sectionVM in sectionVMs {
            let sectionSnapshot = self.generateSnapshot(taskItems: sectionVM.tasks)
            viewController.displayFetchTasks(snapshot: sectionSnapshot, sectionVM: sectionVM, sectionVMs: sectionVMs)
        }
    }
    
    func presentFinshChanged(response: TaskListModels.FinishTask.Response) {
        let taskViewModels = response.tasks.enumerated().map { (idx, task) in
            TaskListModels.TaskVM(task: task)
        }
        viewController.displayFinishChanged(viewModel: .init(displayedTasks: taskViewModels))
    }
    
    func presentFinishDragDrop(viewModel: TaskListModels.DragDropTask.ViewModel) {
        let sourceSnapShot = generateSnapshot(taskItems: viewModel.displayedTasks)
        viewController.displatFinishDragDrop(snapshot: sourceSnapShot, sectionVM: viewModel.sourceSection)
    }
    
    private func generateSnapshot(taskItems: [TaskVM]) -> NSDiffableDataSourceSectionSnapshot<TaskVM> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<TaskVM>()
        func addItems(_ taskItems: [TaskVM], to parent: TaskVM?) {
            snapshot.append(taskItems, to: parent)
            for taskItem in taskItems where !taskItem.subItems.isEmpty {
                addItems(taskItem.subItems, to: taskItem)
                snapshot.expand([taskItem])
            }
        }
        addItems(taskItems, to: nil)
        
        return snapshot
    }
}
