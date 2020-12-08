//
//  MenuViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/27.
//

import UIKit

protocol MenuDisplayLogic: class {
}

class MenuViewController: UIViewController {
    
    typealias Section = MenuModels.ProjectSection
    typealias ProjectVM = MenuModels.ProjectVM
    
    // MARK: - Properties

    private var dataSource: UICollectionViewDiffableDataSource<Section, ProjectVM>!
    private var interactor: MenuBusinessLogic?
    private var rotuer: (MenuDataPassing & MenuRoutingLogic)?
    
    // MARK: Views
    
    @IBOutlet weak private var menuCollectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLogic()
        configureNavItem()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "할고래DO"
        interactor?.fetchProjects()
    }
    
    // MARK: - Initialize
    
    func configureLogic() {
        let presenter = MenuPresenter(viewController: self)
        let interactor = MenuInteractor(presenter: presenter, worker: MenuWorker(sessionManager: SessionManager(configuration: .default)))
        self.interactor = interactor
        self.rotuer = MenuRouter(dataStore: interactor, viewController: self)
    }
    
    func configureNavItem() {
        navigationItem.title = "메뉴"
    }
}


// MARK: - Configure CollectionView Layout

private extension MenuViewController {
    
    func configureCollectionView() {
        menuCollectionView.delegate = self
        menuCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        menuCollectionView.collectionViewLayout = createLayout()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        config.scrollDirection = .vertical
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section: NSCollectionLayoutSection
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.leadingSwipeActionsConfigurationProvider = { [weak self] (indexPath) in
                guard indexPath.row != 0,
                    let self = self,
                    let item = self.dataSource.itemIdentifier(for: indexPath)
                else {
                    return nil
                }
                return self.leadingSwipeAction(item)
            }
            section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            return section
        }
    
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Project>(collectionView: menuCollectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .normal:
                let cellRegistration = indexPath.row == 0 ? self.configuredNormalCell() : self.configuredProjectCell()
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            case .project:
                let cellRegistration = indexPath.row == 0 ? self.configuredProjectHeaderCell() : self.configuredProjectCell()
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        }
    }
    
    func configuredNormalCell() -> UICollectionView.CellRegistration<UICollectionViewListCell, Project> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Project> { (cell, indexPath, project) in
            var content = UIListContentConfiguration.cell()
            content.text = project.title
            content.image = UIImage(systemName: "calendar")
            content.imageProperties.tintColor = .halgoraedoDarkBlue
            content.textProperties.font = .systemFont(ofSize: 20, weight: .medium)
            content.directionalLayoutMargins = .zero
            cell.contentConfiguration = content
            let taskNum = UILabel()
            taskNum.text = "\(project.taskNum)"
            cell.accessories.append(.customView(configuration: .init(customView: taskNum, placement: .trailing())))
        }
    }
    
    func configuredProjectHeaderCell() -> UICollectionView.CellRegistration<UICollectionViewListCell, Project> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Project> { (cell, indexPath, project) in
            var content = cell.defaultContentConfiguration()
            content.text = project.title
            cell.contentConfiguration = content
            var backgroundColor = UIBackgroundConfiguration.listPlainCell()
            backgroundColor.backgroundColor = .systemGray4
            cell.backgroundConfiguration = backgroundColor
            cell.accessories = [.outlineDisclosure()]
        }
    }
    
    func configuredProjectCell() -> UICollectionView.CellRegistration<UICollectionViewListCell, Project> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Project> { (cell, indexPath, project) in
            var content = cell.defaultContentConfiguration()
            content.text = project.title
            content.textProperties.font = .systemFont(ofSize: 17, weight: .light)
            cell.contentConfiguration = content
            cell.indentationLevel = 0
            let taskNum = UILabel()
            taskNum.text = "\(project.taskNum)"
            let starAccessory = UIImageView(image: UIImage(systemName: "star.fill"))
            starAccessory.tintColor = UIColor(hexFromString: project.color!)
            cell.accessories.append(.customView(configuration: .init(customView: taskNum, placement: .trailing())))
            cell.accessories.append(.customView(configuration: .init(customView: starAccessory, placement: .leading())))
        }
    }

    func applyInitialSnapshots() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Project>()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)
        var normalSnapshot = NSDiffableDataSourceSectionSnapshot<Project>()
        normalSnapshot.append(normalItem)
        normalSnapshot.append(Array(heartProjects))
        dataSource.apply(normalSnapshot, to: .normal, animatingDifferences: false)
        
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Project>()
        sectionSnapshot.append([rootItem])
        sectionSnapshot.append(projectItem, to: rootItem)
        sectionSnapshot.expand([rootItem])
        dataSource.apply(sectionSnapshot, to: .project, animatingDifferences: false)
    }
    
    func leadingSwipeAction(_ item: Project) -> UISwipeActionsConfiguration? {
        var normalSnapshot = self.dataSource.snapshot(for: .normal)
        var projectSnapshot = self.dataSource.snapshot(for: .project)
        let isStarred = normalSnapshot.contains(item)
        let starAction = UIContextualAction(style: .normal, title: nil) {
            [weak self] (_, _, completion) in
            guard let self = self else {
                completion(false)
                return
            }
            
            if isStarred {
                normalSnapshot.delete([item])
                projectSnapshot.append([item], to: self.rootItem)
            } else {
                projectSnapshot.delete([item])
                normalSnapshot.append([item])
            }
            self.dataSource.apply(normalSnapshot, to: .normal, animatingDifferences: false)
            self.dataSource.apply(projectSnapshot, to: .project, animatingDifferences: false)
            
            completion(true)
        }
        starAction.image = UIImage(systemName: isStarred ? "heart.slash" : "heart.fill")
        starAction.backgroundColor = .halgoraedoDarkBlue

        return UISwipeActionsConfiguration(actions: [starAction])
    }
}

extension MenuViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let project = dataSource.snapshot().itemIdentifiers[indexPath.item+1]
        guard let vc = storyboard?.instantiateViewController(identifier: "\(TaskListViewController.self)", creator: { (coder) -> TaskListViewController? in
            return TaskListViewController(coder: coder)
        }) else { return }
        vc.title = project.title
        vc.projectTitle = project.title ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Menu DisplayLogic

extension MenuViewController: MenuDisplayLogic {

}