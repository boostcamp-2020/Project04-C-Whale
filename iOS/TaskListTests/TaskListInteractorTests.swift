//
//  TaskListInteractorTests.swift
//  TaskListInteractorTests
//
//  Created by woong on 2020/11/26.
//

import XCTest

class TaskListInteractorTests: XCTestCase {
    
    var interactor: TaskListInteractor!
    var presenter: TaskListPresenterSpy!
    var worker: TaskListWorker!

    override func setUpWithError() throws {
        // Given
        presenter = TaskListPresenterSpy()
        worker = TaskListWorker()
        interactor = TaskListInteractor(presenter: presenter, worker: worker)
    }
    
    func test_change_editingMode_true() {
        // When
        interactor.change(editingMode: true, animated: true)
        
        // Then
        XCTAssertEqual(worker.isEditingMode, true)
        XCTAssertEqual(presenter.setEditingMode, true)
    }
    
    func test_change_editingMode_false() {
        // When
        interactor.change(editingMode: false, animated: true)
        
        // Then
        XCTAssertEqual(worker.isEditingMode, false)
        XCTAssertEqual(presenter.setEditingMode, true)
    }
    
    func test_select_oneTask_editingMode() {
        // When
        interactor.change(editingMode: true, animated: true)
        interactor.select(task: Task(title: "1"))
        
        // Then
        XCTAssertEqual(worker.selectedTasks.count, 1)
        XCTAssertEqual(presenter.presentNumberOfSelectedTasks, 1)
    }
    
    func test_select_task_notEditingMode() {
        // When
        interactor.change(editingMode: false, animated: true)
        let task = Task(title: "1")
        interactor.select(task: task)
        
        // Then
        XCTAssertNotNil(presenter.presentDetail_task)
        XCTAssertEqual(task, presenter.presentDetail_task)
    }
    
    func test_deSelect_hasThreeTask_editingMode() {
        // Given
        interactor.change(editingMode: true, animated: true)
        let t3 = Task(title: "3")
        worker.append(selected: Task(title: "1"))
        worker.append(selected: Task(title: "2"))
        worker.append(selected: t3)
        
        // When
        interactor.deSelect(task: t3)

        // Then
        XCTAssertEqual(worker.selectedTasks.count, 2)
        XCTAssertEqual(presenter.presentNumberOfSelectedTasks, 2)
    }
    
    func test_deSelect_hasThreeTask_not_editingMode_success() {
        // Given
        interactor.change(editingMode: false, animated: true)
        let t1 = Task(title: "1")
        worker.append(selected: t1)
        
        // When
        interactor.deSelect(task: t1)

        // Then
        XCTAssertEqual(worker.selectedTasks.count, 1)
        XCTAssertEqual(presenter.presentNumberOfSelectedTasks, -1)
    }
}
