//
//  NetworkManagerTests.swift
//  ServiceTests
//
//  Created by woong on 2020/12/06.
//

import XCTest

class NetworkManagerTests: XCTestCase {
    
    func test_fetchData_withoutWait_fail() {
        // Given
        let mock = CodableMock(name: "woongs", age: 20)
        let mockData = try? JSONEncoder().encode(mock)
        let mockEp = EndPointMock.test(httpTask: (mockData, nil))
        let mockRequest = DataRequestMock(mockData: mockData)
        let sessionMock = SessionManagerMock(request: mockRequest)
        let manager = NetworkManager(sessionManager: sessionMock)
        var resultData: CodableMock?
        
        // When
        manager.fetchData(mockEp) { (data: CodableMock?, error) in
            resultData = data
        }
        
        // Then
        XCTAssertNil(resultData)
        XCTAssertNotEqual(resultData, mock)
    }
    
    func test_fetchData_success() {
        // Given
        let mock = CodableMock(name: "woongs", age: 20)
        let mockData = try? JSONEncoder().encode(mock)
        let mockEp = EndPointMock.test(httpTask: (mockData, nil))
        let mockRequest = DataRequestMock(mockData: mockData)
        let sessionMock = SessionManagerMock(request: mockRequest)
        let manager = NetworkManager(sessionManager: sessionMock)
        var resultData: CodableMock?
        
        let exp = expectation(description: "Fetch Success")
        
        // When
        manager.fetchData(mockEp) { (data: CodableMock?, error) in
            resultData = data
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 5)
        
        // Then
        XCTAssertEqual(resultData, mock)
    }
}
