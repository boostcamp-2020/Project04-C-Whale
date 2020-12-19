//
//  TaskListGenerator.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/19.
//

import UIKit

class TaskListGenerator {
    
    typealias TaskVM = TaskListModels.TaskVM
    
    var registration = CellRegistration()
}

extension TaskListGenerator {
    struct CellRegistration {
        func normal(doneHandler: ((TaskCollectionViewListCell?, TaskListModels.TaskVM) -> Void)?) -> UICollectionView.CellRegistration<TaskCollectionViewListCell, TaskVM> {
            return UICollectionView.CellRegistration<TaskCollectionViewListCell, TaskVM> { (cell, _: IndexPath, taskItem) in
                cell.indentationWidth = 25
                cell.taskViewModel = taskItem
                cell.doneHandler = doneHandler
                let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .automatic)
                cell.accessories = taskItem.subItems.isEmpty ? [] : [.outlineDisclosure(options: disclosureOptions)]
            }
        }
    }
}
