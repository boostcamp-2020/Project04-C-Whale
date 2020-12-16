//
//  TaskListDisplayLogic.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/26.
//

import UIKit

protocol TaskListDisplayLogic {
    func displayFetchTasks(snapshot: NSDiffableDataSourceSectionSnapshot<TaskListModels.TaskVM>, sectionVM: TaskListModels.SectionVM, sectionVMs: [TaskListModels.SectionVM])
    func displayFinishChanged(viewModel: TaskListModels.FinishTask.ViewModel)
    func displatFinishDragDrop(snapshot: NSDiffableDataSourceSectionSnapshot<TaskListModels.TaskVM>, sectionVM: TaskListModels.SectionVM)
}
