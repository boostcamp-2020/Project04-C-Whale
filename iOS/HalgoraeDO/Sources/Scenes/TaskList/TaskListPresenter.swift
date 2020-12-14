//
//  TaskListPresenter.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import Foundation

protocol TaskListPresentLogic {
    func presentFetchTasks(response: TaskListModels.FetchTasks.Response)
    func presentFetchTasksForAll(response: TaskListModels.FetchTasks.Response)
    func presentDetail(of task: Task)
    func presentFinshChanged(response: TaskListModels.FinishTask.Response)
}

class TaskListPresenter {
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
        viewController.displayFetchTasks(viewModel: TaskListModels.FetchTasks.ViewModel(sectionVMs: tempSectionVM))
    }
    
    func presentFetchTasksForAll(response: TaskListModels.FetchTasks.Response) {
        let sectionVMs = response.sections.compactMap { TaskListModels.SectionVM(section: $0) }
        viewController.displayFetchTasks(viewModel: TaskListModels.FetchTasks.ViewModel(sectionVMs: sectionVMs))
    }
    
    func presentDetail(of task: Task) {
        
    }
    
    func presentFinshChanged(response: TaskListModels.FinishTask.Response) {
        let taskViewModels = response.tasks.enumerated().map { (idx, task) in
            TaskListModels.DisplayedTask(task: task)
        }
    }
}
