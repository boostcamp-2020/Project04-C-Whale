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
    
    func configureLayout(leadingSwipeAction: @escaping (_ indexPath: IndexPath) -> UIContextualAction) -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfiguration.leadingSwipeActionsConfigurationProvider = { indexPath in
            return UISwipeActionsConfiguration(actions: [(leadingSwipeAction(indexPath))])
        }
        listConfiguration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
        return layout
    }
    
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
        
        func header(sections: [TaskListModels.SectionVM]) -> UICollectionView.SupplementaryRegistration<TaskBoardSupplementaryView> {
            return UICollectionView.SupplementaryRegistration<TaskBoardSupplementaryView>(elementKind: "Header") {
                (supplementaryView, string, indexPath) in
                let section = sections[indexPath.section]
                supplementaryView.configureHeader(sectionName: section.title, rowNum: section.tasks.count)
            }
        }
    }
}
