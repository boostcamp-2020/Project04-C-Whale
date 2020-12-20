//
//  DetailSubPageViewController.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/01.
//

import UIKit

class TaskDetailPageViewController: UIPageViewController {
    
    // MARK: - Properties
    
    lazy var pages: [UIViewController] = []
    private var interactor: TaskListBusinessLogic?
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController()
    }
    
    // MARK: - Initialize
    
    func configureLogic(interactor: TaskListBusinessLogic) {
        self.interactor = interactor
    }
    
    private func configurePageViewController() {
        self.dataSource = self
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func instance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: name)
    }
}

// MARK: - UIPageViewController DataSource

extension TaskDetailPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = pageIndex - 1
        
        return previousIndex < 0 ? pages.last : pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = pageIndex + 1
        
        return nextIndex >= pages.count ? pages.first : pages[nextIndex]
    }
}
