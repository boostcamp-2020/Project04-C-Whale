//
//  TaskBoardViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import UIKit

class TaskBoardViewController: UIViewController {
    
    typealias TaskVM = TaskListModels.DisplayedTask
    
    // MARK: - Properties
    
    private var interactor: TaskListBusinessLogic?
    private var router: (TaskListRoutingLogic & TaskListDataPassing)?
    private var dataSource: UICollectionViewDiffableDataSource<String, TaskVM>! = nil
    private var lineView: UIView = UIView()
    private var startIndex: IndexPath?
    private var startPoint: CGPoint?
    private let visualEffectView = UIVisualEffectView()
    private var taskAddViewController: TaskAddViewController = TaskAddViewController()
    private var taskVM: [TaskVM] = []
    let sections = ["할고래두 TODO List", "할고라니까?? Todo!!", "진짜할고래DO???"]
    
    // MARK: - Views
    
    @IBOutlet weak private var taskBoardCollectionView: UICollectionView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogic()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchTasks(request: .init(showCompleted: false))
    }
    
    // MARK: - Initialize
    
    private func configureLogic() {
        let presenter = TaskListPresenter(viewController: self)
        let interactor = TaskListInteractor(presenter: presenter, worker: TaskListWorker())
        self.interactor = interactor
    }
    
    //MARK: - Helper Method

    // MARK:  IBActions
    @IBAction func didTapMoreButton(_ sender: UIBarButtonItem) {
        guard !isEditing else {
            setEditing(false, animated: true)
            return
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let showBoardAction = UIAlertAction(title: "목록으로 보기", style: .default) { [weak self] (_: UIAlertAction) in
            guard let vc = self?.storyboard?.instantiateViewController(identifier: String(describing: TaskListViewController.self), creator: { coder -> TaskListViewController? in
                return TaskListViewController(coder: coder)
            }) else { return }
            
            let nav = self?.navigationController
            nav?.popViewController(animated: false)
            nav?.pushViewController(vc, animated: false)
        }
        
        let addSectionAction = UIAlertAction(title: "섹션 추가", style: .default) { (_: UIAlertAction) in
            
        }
        
        let addTaskAction = UIAlertAction(title: "작업 추가", style: .default) { [weak self] (_: UIAlertAction) in
            self?.showAddTaskView()
        }
        
        let selectTaskAction = UIAlertAction(title: "작업 선택", style: .default) { [weak self] (_: UIAlertAction) in
            self?.setEditing(true, animated: true)
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
        taskBoardCollectionView.reloadData()
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
    
    func showAddTaskView() {
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        taskAddViewController = TaskAddViewController()
        addChild(taskAddViewController)
        view.addSubview(taskAddViewController.view)
        taskAddViewController.view.backgroundColor = .white
        taskAddViewController.view.frame = CGRect(x: 0, y: view.bounds.height - 130, width: view.bounds.width, height: 130)
        visualEffectView.backgroundColor = .gray
        visualEffectView.alpha = 0.4
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewTap(recognizer:))))
    }
    
    @objc func handleViewTap (recognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let selectTaskAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] (action) in
            self?.taskAddViewController.view.removeFromSuperview()
            self?.visualEffectView.removeFromSuperview()
        }
        let cancelAction = UIAlertAction(title: "계속 편집", style: .default) { (action) in
        }
        [selectTaskAction, cancelAction].forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionView DataSource

extension TaskBoardViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count + 1 //Section 갯수 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 //고정
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section < sections.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "section-reuse-identifier", for: indexPath) as! TaskSectionViewCell
            cell.configure(sectionName: sections[indexPath.section], task: taskVM)
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "section-add-reuse-identifier", for: indexPath) as! AddSectionViewCell
            cell.configCollectionViewCell()
            return cell
        }
    }
    
}

// MARK: - TaskList Display Logic

extension TaskBoardViewController: TaskListDisplayLogic {
    
    func displayFetchTasks(viewModel: TaskListModels.FetchTasks.ViewModel) {
        taskVM = viewModel.displayedTasks
    }
    
    func displayDetail(of task: Task) {
        
    }
    
}
