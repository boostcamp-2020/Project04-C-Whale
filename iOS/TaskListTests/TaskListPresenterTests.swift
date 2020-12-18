//
//  TaskListPresenterTests.swift
//  TaskListTests
//
//  Created by woong on 2020/12/18.
//

import XCTest
import CoreData

class TaskListPresenterTests: XCTestCase {
    
    var presenter: TaskListPresenter!
    var viewController: TaskListViewControllerSpy!
    var context: NSManagedObjectContext {
        return PersistentContainerMock.shared.childContext
    }
    var dummySections: [Section] {
        let sections = [Section(context: context)]
        sections.forEach { $0.tasks = NSOrderedSet(array: dummyTasks) }
        return sections
    }
    
    var dummyTasks: [Task] {
        let testTasks = [
            Task(context: context),
            Task(context: context),
            Task(context: context)
        ]
        testTasks.enumerated().forEach {
            $0.element.title = "\($0.offset)"
        }
        return testTasks
    }

    override func setUpWithError() throws {
        viewController = TaskListViewControllerSpy()
        presenter = TaskListPresenter(viewController: viewController)
    }

    override func tearDownWithError() throws {
        presenter = nil
    }
    
    func test_FetchTasks() {
        // Given
        let sections = dummySections
        let resultVMs = sections.map {
            TaskListModels.SectionVM(section: $0)
        }
        
        // When
        presenter.presentFetchTasks(response: .init(sections: sections))
        
        // Then
        XCTAssertEqual(resultVMs, viewController.displayFetchTasksViewModel?.sectionVMs)
    }
    
    func test_FetchTasksForAll() {
        // Given
        let sections = dummySections
        let resultVMs = sections.map {
            TaskListModels.SectionVM(section: $0)
        }
        
        // When
        presenter.presentFetchTasks(response: .init(sections: sections))
        
        // Then
        XCTAssertEqual(resultVMs, viewController.displayFetchTasksViewModel?.sectionVMs)
    }
    
    func test_FinishChanged() {
        // Given
        let tasks = dummyTasks
        let resultVMs = tasks.map {
            TaskListModels.TaskVM(task: $0)
        }
        
        // When
        presenter.presentFinshChanged(response: .init(tasks: tasks))
        
        // Then
        XCTAssertEqual(resultVMs, viewController.displayFinishChangedViewModel?.displayedTasks)
    }
}
