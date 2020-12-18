//
//  TaskListInteractorTests.swift
//  TaskListTests
//
//  Created by woong on 2020/12/17.
//

import XCTest

class TaskListInteractorTests: XCTestCase {
    
    var viewController: TaskListViewControllerMock!
    var presenter: TaskListPresenterMock!
    var worker: TaskListWorker!
    var sessionManager: SessionManagerMock!

    override func setUpWithError() throws {
        viewController = TaskListViewControllerMock()
        presenter = TaskListPresenterMock()
        sessionManager = SessionManagerMock(request: DataRequestMock())
        worker = TaskListWorker(sessionManager: sessionManager)
    }
    
    func testInit() {
        // When
        let interactor = TaskListInteractor(presenter: presenter, worker: worker)
        
        // Then
        XCTAssertNotNil(interactor)
    }
}
