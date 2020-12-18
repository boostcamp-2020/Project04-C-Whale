//
//  WorkerTests.swift
//  TaskListTests
//
//  Created by woong on 2020/12/17.
//

import XCTest

class TaskListWorkerTests: XCTestCase {
    
    let mock = CodableMock(name: "woongs", age: 20)
    var mockRequest: DataRequestMock!
    var sessionMock: SessionManagerMock!

    override func setUpWithError() throws {
        let mockData = try? JSONEncoder().encode(mock)
        self.mockRequest = DataRequestMock(mockData: mockData)
        self.sessionMock = SessionManagerMock(request: mockRequest)
    }
    
    func testInit() {
        // When
        let worker = TaskListWorker(sessionManager: sessionMock)
        
        // Then
        XCTAssertNotNil(worker)
    }
    
    func testRequest_sucess() {
        // Given
        let worker = TaskListWorker(sessionManager: sessionMock)
        let mockEndPoint = EndPointMock.test()
        
        // When
        worker.request(endPoint: mockEndPoint) { (response: CodableMock?) in
            // Then
            XCTAssertEqual(self.mock, response)
        }
    }
    
    func testRequest_fail() {
        // Given
        let failMock = CodableMock(name: "hi", age: 30)
        let worker = TaskListWorker(sessionManager: sessionMock)
        let mockEndPoint = EndPointMock.test()

        // When
        worker.request(endPoint: mockEndPoint) { (response: CodableMock?) in
            // Then
            XCTAssertNotEqual(self.mock, failMock)
        }
    }
    
    func testRequest_resultIsEmpty() {
        // Given
        sessionMock.request.mockData = nil
        let worker = TaskListWorker(sessionManager: sessionMock)
        let mockEndPoint = EndPointMock.test()

        // When
        worker.request(endPoint: mockEndPoint) { (response: CodableMock?) in
            // Then
            XCTAssertEqual(response, nil)
        }
    }
}
