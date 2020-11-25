//
//  TaskListWorkerTests.swift
//  TaskListWorkerTests
//
//  Created by woong on 2020/11/25.
//

import XCTest

class TaskListWorkerTests: XCTestCase {
    
    func test_numberOfSelectedTasks_init() {
        // When
        let worker = TaskListWorker()
        
        // Then
        XCTAssertEqual(worker.selectedTasks.count, 0)
    }
    
    func test_editingMode_false_init() {
        // When
        let worker = TaskListWorker()
        
        // Then
        XCTAssertEqual(worker.isEditingMode, false)
    }
    
    func test_append_editingMode_on() {
        // Given
        let worker = TaskListWorker()
        worker.isEditingMode = true
        
        // When
        worker.append(selected: Task(title: "test"))
        
        // Then
        XCTAssertEqual(worker.selectedTasks.count, 1)
    }
    
    func test_remove_onEditingMode() {
        // Given
        let worker = TaskListWorker()
        worker.isEditingMode = true
        let task = Task(title: "test")
        
        // When
        worker.append(selected: task)
        worker.remove(selected: task)
        
        // Then
        XCTAssertEqual(worker.selectedTasks.count, 0)
    }
    
    func test_selectedTasks_empty_turnOffEditingMode_success() {
        // Given
        let worker = TaskListWorker()
        worker.isEditingMode = true
        worker.append(selected: Task(title: "1"))
        worker.append(selected: Task(title: "1"))
        worker.append(selected: Task(title: "1"))
        
        // When
        worker.isEditingMode = false
        
        // Then
        XCTAssertEqual(worker.selectedTasks.isEmpty, true)
    }
}
