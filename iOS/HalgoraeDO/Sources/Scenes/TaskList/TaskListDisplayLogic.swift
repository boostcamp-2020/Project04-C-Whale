//
//  TaskListDisplayLogic.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/26.
//

import Foundation

protocol TaskListDisplayLogic {
    func displayFetchTasks(viewModel: TaskListModels.FetchTasks.ViewModel)
    func displayDetail(of task: Task)
    func displayFinishChanged(viewModel: TaskListModels.FinishTask.ViewModel)
}
