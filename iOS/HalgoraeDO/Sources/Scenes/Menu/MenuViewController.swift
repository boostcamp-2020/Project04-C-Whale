//
//  MenuViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/27.
//

import UIKit

protocol MenuDisplayLogic: class {
    func displayFetchedProjects(viewModel: MenuModels.FetchProjects.ViewModel)
    func displayUpdatedProject(viewModel: MenuModels.UpdateProject.ViewModel)
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
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .halgoraedoMint
        refreshControl.addTarget(self, action: #selector(didChangeRefersh(_:)), for: .valueChanged)
        
        return refreshControl
    }()
    
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
        interactor?.fetchProjects()
    }
    
    // MARK: - Initialize
    
    func configureLogic() {
        let presenter = MenuPresenter(viewController: self)
        let interactor = MenuInteractor(presenter: presenter,
                                        worker: MenuWorker(sessionManager: SessionManager(configuration: .default),
                                                           storage: Storage()))
        self.interactor = interactor
        self.rotuer = MenuRouter(dataStore: interactor, viewController: self)
    }
    
    func configureNavItem() {
        navigationItem.title = "메뉴"
    }
    
    // MARK: - Methods
    
    @objc private func didChangeRefersh(_ sender: UIRefreshControl) {
        interactor?.fetchProjects()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func deleteSnapshot(for items: [ProjectVM]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(items)
        dataSource.apply(snapshot)
    }
    
    private func appendSnapshot(items: [ProjectVM], to: Section) {
        var normalSnapshot = dataSource.snapshot(for: .normal)
        normalSnapshot.append(items)
        dataSource.apply(normalSnapshot, to: .normal)
    }
}


// MARK: - Configure CollectionView Layout

private extension MenuViewController {
    
    func configureCollectionView() {
        menuCollectionView.collectionViewLayout = createLayout()
        menuCollectionView.refreshControl = refreshControl
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
        let cellGenerator = MenuCellGenerator()
        dataSource = UICollectionViewDiffableDataSource<Section, ProjectVM>(collectionView: menuCollectionView) {
            [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError() }
            switch section {
            case .normal:
                let cellRegistration = indexPath.row == 0 ? cellGenerator.registrateNormal() : cellGenerator.registrateProject()
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            case .project:
                let cellRegistration = indexPath.row == 0 ? cellGenerator.registrateHeader(addSelector: #selector(self?.tabAddProject(_:))) : cellGenerator.registrateProject()
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        }
    }
    
    func applySnapshot(projects: [Section: [ProjectVM]]) {
        for (section, projectVMs) in projects.sorted(by: { $0.key.rawValue < $1.key.rawValue }) {
            guard !projectVMs.isEmpty else { continue }
            var projectVMs = projectVMs
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ProjectVM>()
            
            let header = projectVMs.removeFirst()
            sectionSnapshot.append([header])
            sectionSnapshot.append(projectVMs, to: header)
            sectionSnapshot.expand([header])
            DispatchQueue.main.async {
                self.dataSource.apply(sectionSnapshot, to: section)
            }
        }
    }

    func leadingSwipeAction(_ item: ProjectVM) -> UISwipeActionsConfiguration? {
        let starAction = UIContextualAction(style: .normal, title: nil) {
            [weak self] (_, _, completion) in
            var tempItem = item
            tempItem.isFavorite = !item.isFavorite
            self?.interactor?.updateProject(request: .init(project: tempItem))
            completion(true)
        }
        starAction.image = UIImage(systemName: item.isFavorite ? "heart.slash" : "heart.fill")
        starAction.backgroundColor = .halgoraedoDarkBlue

        return UISwipeActionsConfiguration(actions: [starAction])
    }
    
    // MARK: Help Function
    
    @objc func tabAddProject(_ sender: UIButton) {
        guard let addProjectViewController = storyboard?.instantiateViewController(identifier: "AddProjectViewController") as? AddProjectViewController else { return }
        addProjectViewController.addProjectViewControllerDelegate = self
        self.present(addProjectViewController, animated: true, completion: nil)
    }
}

extension MenuViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let project = dataSource.itemIdentifier(for: indexPath),
              !project.isHeader
        else {
            return
        }
        
        rotuer?.routeToTaskList(for: project)
    }
}

// MARK: - AddProjectViewController Delegate

extension MenuViewController: AddProjectViewControllerDelegate {
    
    func addProjectViewController(_ addProjectViewController: AddProjectViewController, didDoneFor projectData: MenuModels.ProjectFields) {
        interactor?.createProject(request: .init(projectFields: projectData))
    }
}
// MARK: - Menu DisplayLogic

extension MenuViewController: MenuDisplayLogic {
    
    func displayFetchedProjects(viewModel: MenuModels.FetchProjects.ViewModel) {
        applySnapshot(projects: viewModel.projects)
    }
    
    func displayUpdatedProject(viewModel: MenuModels.UpdateProject.ViewModel) {
        
        let favorite = viewModel.favorite
        if favorite.isFavorite {
            appendSnapshot(items: [favorite], to: .normal)
        } else {
            deleteSnapshot(for: [favorite])
        }
        
        let project = viewModel.project
        var sectionSnapshot = dataSource.snapshot(for: .project)
        let originIndex = sectionSnapshot.index(of: project)
        sectionSnapshot.delete([project])
        
        if 0..<sectionSnapshot.items.count ~= originIndex ?? -1 {
            let nextItem = sectionSnapshot.items[originIndex!]
            sectionSnapshot.insert([project], before: nextItem)
        } else {
            sectionSnapshot.append([project])
        }

        dataSource.apply(sectionSnapshot, to: .project)
    }
}
