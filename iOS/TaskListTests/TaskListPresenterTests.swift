//
//  TaskListPresenterTests.swift
//  TaskListPresenterTests
//
//  Created by woong on 2020/11/26.
//

import XCTest

class TaskListPresenterTests: XCTestCase {
    
    var presenter: TaskListPresenter!
    var taskListDisplaySpy: TaskListDisplaySpy!
    
    override func setUpWithError() throws {
        // Given
        taskListDisplaySpy = TaskListDisplaySpy()
        presenter = TaskListPresenter(viewController: taskListDisplaySpy)
    }
    
    func test_presenter_init() {
        // Then
        XCTAssertNotNil(presenter)
    }
}
