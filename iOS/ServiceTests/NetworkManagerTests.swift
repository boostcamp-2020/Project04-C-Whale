//
//  NetworkManagerTests.swift
//  ServiceTests
//
//  Created by woong on 2020/12/06.
//

import XCTest

class NetworkManagerTests: XCTestCase {
    
    func test_fetchData() {
        // Given
        let mock = CodableMock(name: "woongs", age: 20)
        let mockData = try? JSONEncoder().encode(mock)
        let mockEp = EndPointMock.test(httpTask: (mockData, nil))
        let mockRequest = DataRequestMock(mockData: mockData)
        let sessionMock = SessionManagerMock(request: mockRequest)
        let manager = NetworkManager(sessionManager: sessionMock)
        
        // When Then
        manager.fetchData(mockEp) { (data: CodableMock?, error) in
            XCTAssertEqual(data, mock)
        }
    }
}
