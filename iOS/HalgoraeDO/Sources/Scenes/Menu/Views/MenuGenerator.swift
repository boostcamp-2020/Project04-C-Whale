//
//  CellGenerator.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/19.
//

import UIKit

class MenuGenerator {
    
    typealias ProjectVM = MenuModels.ProjectVM
    
    var registration = CellRegistration()
    
    func configureLayout(configuration: UICollectionLayoutListConfiguration) -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        config.scrollDirection = .vertical
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        }
    
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
    }
}

extension MenuGenerator {
    struct CellRegistration {
        func normal() -> UICollectionView.CellRegistration<UICollectionViewListCell, ProjectVM> {
            return UICollectionView.CellRegistration<UICollectionViewListCell, ProjectVM> { (cell, indexPath, project) in
                var content = cell.defaultContentConfiguration()
                content.text = project.title
                content.image = UIImage(systemName: "calendar")
                content.imageProperties.tintColor = .halgoraedoDarkBlue
                content.textProperties.font = .systemFont(ofSize: 20, weight: .medium)
                content.directionalLayoutMargins = .zero
                cell.contentConfiguration = content
                let taskNum = UILabel()
                taskNum.text = "\(project.taskCount)"
                cell.accessories.append(.customView(configuration: .init(customView: taskNum, placement: .trailing())))
            }
        }
        
        func header(addSelector: Selector) -> UICollectionView.CellRegistration<UICollectionViewListCell, ProjectVM> {
            return UICollectionView.CellRegistration<UICollectionViewListCell, ProjectVM> { (cell, indexPath, project) in
                var content = cell.defaultContentConfiguration()
                content.text = project.title
                cell.contentConfiguration = content
                var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
                backgroundConfig.backgroundColor = .systemGray6
                cell.backgroundConfiguration = backgroundConfig
                cell.accessories = [.outlineDisclosure()]
                let addProjectButton = UIButton()
                addProjectButton.setImage(UIImage(systemName: "plus"), for: .normal)
                addProjectButton.alpha = 0.5
                addProjectButton.tintColor = .gray
                addProjectButton.addTarget(self, action: addSelector, for: .touchUpInside)
                cell.accessories.append(.customView(configuration: .init(customView: addProjectButton, placement: .trailing())))
            }
        }
        
        func project() -> UICollectionView.CellRegistration<UICollectionViewListCell, ProjectVM> {
            return UICollectionView.CellRegistration<UICollectionViewListCell, ProjectVM> { (cell, indexPath, project) in
                var content = cell.defaultContentConfiguration()
                content.text = project.title
                content.textProperties.font = .systemFont(ofSize: 17, weight: .light)
                cell.contentConfiguration = content
                cell.indentationLevel = 0
                let taskNum = UILabel()
                taskNum.text = "\(project.taskCount)"
                let starAccessory = UIImageView(image: UIImage(systemName: "star.fill"))
                starAccessory.tintColor = UIColor(hexFromString: project.color)
                cell.accessories.append(.customView(configuration: .init(customView: taskNum, placement: .trailing())))
                cell.accessories.append(.customView(configuration: .init(customView: starAccessory, placement: .leading())))
            }
        }
    }
}
