//
//  TaskListInteractorTests.swift
//  TaskListTests
//
//  Created by woong on 2020/12/17.
//

import XCTest
import CoreData

class TaskListInteractorTests: XCTestCase {
    
    var viewController: TaskListViewControllerSpy!
    var presenter: TaskListPresenterSpy!
    var worker: TaskListWorker!
    var sessionManager: SessionManagerMock!
    var interactor: TaskListInteractor!
    var context: NSManagedObjectContext {
        return PersistentContainerMock.shared.childContext
    }
    
    func dummyProject(projectId: String) -> Project {
        let projectId = projectId
        let project = Project(context: context)
        project.id = projectId
        let sections = [Section(context: context)]
        let testTasks = [
            Task(context: context),
            Task(context: context),
            Task(context: context)
        ]
        testTasks.enumerated().forEach {
            $0.element.title = "\($0.offset)"
        }
        sections.forEach { $0.tasks = NSOrderedSet(array: testTasks) }
        project.sections = NSOrderedSet(array: sections)
        return project
    }

    override func setUpWithError() throws {
        viewController = TaskListViewControllerSpy()
        presenter = TaskListPresenterSpy()
        sessionManager = SessionManagerMock(request: DataRequestMock())
        worker = TaskListWorker(sessionManager: sessionManager)
        interactor = TaskListInteractor(presenter: presenter, worker: worker)
    }
    
    override func tearDownWithError() throws {
        viewController = nil
        presenter = nil
        worker = nil
        sessionManager = nil
    }
    
    func testInit() {
        // Then
        XCTAssertNotNil(viewController)
        XCTAssertNotNil(presenter)
        XCTAssertNotNil(worker)
        XCTAssertNotNil(sessionManager)
    }
    
    func test_FetchTasks_response_sectionsOfproject_success() {
        // Given
        let projectId = "p1"
        let responseProject = dummyProject(projectId: projectId)
        let response = Response(project: responseProject)
        sessionManager.request.mockData = response.encodeData
        
        // When
        interactor.fetchTasks(request: .init(projectId: projectId))
        // Then
        XCTAssertEqual(presenter.presentFetchTasksResponse?.sections, responseProject.sections?.array as? [Section])
    }
    
    func test_fetchTasksForComplete() {
        // Given
        let projectId = "p1"
        let responseProject = dummyProject(projectId: projectId)
        let response = Response(project: responseProject)
        sessionManager.request.mockData = response.encodeData
        
        // When
        interactor.fetchTasksForComplete(request: .init(projectId: projectId))
        
        // Then
        XCTAssertEqual(presenter.presentFetchTasksResponse?.sections, responseProject.sections?.array as? [Section])
    }
}
