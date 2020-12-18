//
//  TaskListDisplayLogic.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/26.
//

import UIKit

protocol TaskListDisplayLogic {
    func displayFetchTasks(viewModel: TaskListModels.FetchTasks.ViewModel)
    func displayFinishChanged(viewModel: TaskListModels.FinishTask.ViewModel)
    func displayFinishDragDrop(viewModel: TaskListModels.DragDropTask.ViewModel)
}
