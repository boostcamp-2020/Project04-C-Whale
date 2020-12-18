//
//  TaskBoardViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

class TaskBoardViewController: UIViewController {
    
    typealias TaskVM = TaskListModels.TaskVM
    
    // MARK: - Properties
    
    var project: Project
    private var interactor: TaskListBusinessLogic?
    private var router: (TaskListRoutingLogic & TaskListDataPassing)?
    private var dataSource: UICollectionViewDiffableDataSource<String, TaskVM>! = nil
    private var taskAddViewController: TaskAddViewController = TaskAddViewController()
    private var sectionVM: [TaskListModels.SectionVM] = []
    
    // MARK: - Views
    
    @IBOutlet weak private var taskBoardCollectionView: UICollectionView!
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .halgoraedoMint
        refreshControl.addTarget(self, action: #selector(didChangeRefersh(_:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    // MARK: - View Life Cycle
    
    init?(coder: NSCoder, project: Project) {
        self.project = project
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.project = Project(context: Storage().childContext)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(displayAddTask), name: NSNotification.Name(rawValue: "displayAddTask"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addSection), name: NSNotification.Name(rawValue: "addSection"), object: nil)
        configureLogic()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        interactor?.fetchTasks(request: .init(projectId: project.id))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Initialize
    
    private func configureLogic() {
        let presenter = TaskListPresenter(viewController: self)
        let interactor = TaskListInteractor(presenter: presenter, worker: TaskListWorker(sessionManager: SessionManager(configuration: .default)))
        self.interactor = interactor
        self.router = TaskListRouter(viewController: nil, boardViewController: self, dataStore: interactor)
        
    }
    
    //MARK: - Helper Method
    
    @objc private func displayAddTask(_ notification: Notification) {
        guard let object = notification.object as? Int
        else { return }
        showAddTaskView(sectionNum: object)
    }
    
    @objc private func addSection(_ notification: Notification) {
        addSectionAlert()
    }
    
    @objc func didChangeRefersh(_ sender: UIRefreshControl) {
        interactor?.fetchTasks(request: .init(projectId: project.id))
        sender.endRefreshing()
    }
    
    private func addSectionAlert() {
        let alert = UIAlertController(title: "섹션 추가", message: "예. 3주차 할일", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            guard let sectionName = alert.textFields?[0].text,
                  sectionName != ""
            else {
                return
            }
            let projectId = self.project.id
            let sectionFields = TaskListModels.SectionFields(title: sectionName)
            self.interactor?.createSection(request: .init(projectId: projectId, sectionFields: sectionFields))
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        alert.addTextField { (textField) in
            textField.placeholder = "섹션 이름을 입력해주세요."
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: IBActions
    
    @IBAction private func didTapMoreButton(_ sender: UIBarButtonItem) {
        guard !isEditing else {
            setEditing(false, animated: true)
            return
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let showBoardAction = UIAlertAction(title: "목록으로 보기", style: .default) { (_: UIAlertAction) in
            guard let vc = self.storyboard?.instantiateViewController(identifier: String(describing: TaskListViewController.self), creator: { coder -> TaskListViewController? in
                return TaskListViewController(coder: coder)
            }) else {
                return
            }
            vc.project = self.project
            let nav = self.navigationController
            nav?.popViewController(animated: false)
            nav?.pushViewController(vc, animated: false)
        }
        
        let addSectionAction = UIAlertAction(title: "섹션 추가", style: .default) { (_: UIAlertAction) in
            self.addSectionAlert()
        }
        
        let addTaskAction = UIAlertAction(title: "작업 추가", style: .default) { (_: UIAlertAction) in
            self.showAddTaskView(sectionNum: 0)
        }
        
        let selectTaskAction = UIAlertAction(title: "작업 선택", style: .default) { (_: UIAlertAction) in
            self.setEditing(true, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_: UIAlertAction) in
            
        }
        
        [showBoardAction, addSectionAction, addTaskAction, selectTaskAction, cancelAction].forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Configure CollectionView Layout

private extension TaskBoardViewController {
    
    func configureCollectionView() {
        taskBoardCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        taskBoardCollectionView.collectionViewLayout = createCompositionalLayout()
        taskBoardCollectionView.register(TaskSectionViewCell.self, forCellWithReuseIdentifier: "section-reuse-identifier")
        taskBoardCollectionView.register(AddSectionViewCell.self, forCellWithReuseIdentifier: "section-add-reuse-identifier")
        taskBoardCollectionView.isPagingEnabled = true
        taskBoardCollectionView.refreshControl = refreshControl
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 0
        config.scrollDirection = .horizontal
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section: NSCollectionLayoutSection
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .paging
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
    }
}

// MARK: - Add Task View Login

private extension TaskBoardViewController {
    
    func showAddTaskView(sectionNum: Int) {
        let taskAddViewController = TaskAddViewController()
        taskAddViewController.delegate = self
        taskAddViewController.sectionNum = sectionNum
        taskAddViewController.modalPresentationStyle = .overCurrentContext
        present(taskAddViewController, animated: true, completion: nil)
    }
}

// MARK: - TaskAddViewController Delegate

extension TaskBoardViewController: TaskAddViewControllerDelegate {
    
    func taskAddViewControllerDidDone(_ taskAddViewController: TaskAddViewController) {
        guard let sectionNum = taskAddViewController.sectionNum else { return }
        let projectId = project.id
        let sectionId = sectionVM[sectionNum].id
        let taskFields = TaskListModels.TaskFields(title: taskAddViewController.text,
                                                   date: taskAddViewController.date,
                                                   priority: "\(taskAddViewController.priority.rawValue)")
        
        interactor?.createTask(request: .init(projectId: projectId, sectionId: sectionId, taskFields: taskFields))
        taskAddViewController.dismiss(animated: false, completion: nil)
    }
}


// MARK: - UICollectionView DataSource

extension TaskBoardViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let addSectionCell = 1
        return sectionVM.count + addSectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section < sectionVM.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "section-reuse-identifier", for: indexPath) as! TaskSectionViewCell
            cell.configure(section: sectionVM[indexPath.section], sectionNum: indexPath.section)
            cell.taskSectionViewCellDelegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "section-add-reuse-identifier", for: indexPath) as! AddSectionViewCell
            cell.configCollectionViewCell()
            
            return cell
        }
    }
}

// MARK: - TaskList Display Logic

extension TaskBoardViewController: TaskListDisplayLogic {
    
    func displayFetchTasks(viewModel: TaskListModels.FetchTasks.ViewModel) {
        self.sectionVM = viewModel.sectionVMs
        DispatchQueue.main.async {
            self.taskBoardCollectionView.reloadData()
        }
    }
    
    func displayFinishDragDrop(viewModel: TaskListModels.DragDropTask.ViewModel) {
        guard let sectionIndex = viewModel.sectionIndex,
              let tasks = viewModel.tasks,
              let newSectionVM = viewModel.sectionVMs
        else { return }
        self.sectionVM = newSectionVM
        guard let sectionCell = taskBoardCollectionView.cellForItem(at: IndexPath(row: 0, section: sectionIndex)) as? TaskSectionViewCell else {
            taskBoardCollectionView.reloadItems(at: [IndexPath(row: 0, section: sectionIndex)])
            return
        }
        sectionCell.reloadSnapshot(taskItems: tasks, sectionVM: newSectionVM[sectionIndex])
    }

    func displayFinishChanged(viewModel: TaskListModels.FinishTask.ViewModel) {
        
    }
}

// MARK: - Move Cell Delegate Logic

extension TaskBoardViewController: TaskSectionViewCellDelegate {
    
    func taskSectionViewCell(_ taskSectionViewCell: TaskSectionViewCell, didSelectedTask task: TaskListModels.TaskVM, at section: Int) {
        router?.routeToTaskDetailFromBoard(for: task, at: .init(item: 0, section: section))
    }
    
    func taskSectionViewCellDidPullToRefresh(_ taskSectionViewCell: TaskSectionViewCell) {
        interactor?.fetchTasks(request: .init(projectId: project.id))
    }
    
    func taskSectionViewCell(_ taskSectionViewCell: TaskSectionViewCell, _ sourceSection: TaskListModels.SectionVM, _ destinationSection: TaskListModels.SectionVM, _ sourceTask: TaskListModels.TaskVM, _ destinationTask: TaskListModels.TaskVM?) {
        interactor?.dragDropForBoard(requset: .init(projectId: project.id, sectionViewModel: sectionVM, sourceSection: sourceSection, destinationSection: destinationSection, sourceTask: sourceTask, destinationTask: destinationTask))
    }
}

