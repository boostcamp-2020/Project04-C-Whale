//
//  SessionManagerTests.swift
//  ServiceTests
//
//  Created by woong on 2020/12/06.
//

import XCTest

class SessionManagerTests: XCTestCase {

    var defaultSession: SessionManager!
    var codableMock: CodableMock!
    

    override func setUpWithError() throws {
        defaultSession = SessionManager(configuration: .default)
        codableMock = CodableMock(name: "woongs", age: 20)
    }
    
    func testRequest_baseURL_DefaultSession() {
        // Given
        let endPoint = EndPointMock.test()
        
        // When
        let request = defaultSession.request(endPoint: endPoint)
        
        // Then
        XCTAssertEqual(request.request.url, endPoint.baseURL)
    }
    
    func testRequest_pathURL_DefaultSession() {
        // Given
        let path = "test"
        let endPoint = EndPointMock.test(path: path)
        
        // When
        let request = defaultSession.request(endPoint: endPoint)
        
        // Then
        var pathURL = endPoint.baseURL
        pathURL.appendPathComponent(path)
        XCTAssertEqual(request.request.url, pathURL)
    }
    
    func testRequest_pathURL_withSlash_DefaultSession() {
        // Given
        let path = "test/"
        let endPoint = EndPointMock.test(path: path)
        
        // When
        let request = defaultSession.request(endPoint: endPoint)
        
        // Then
        var pathURL = endPoint.baseURL
        pathURL.appendPathComponent(path)
        XCTAssertEqual(request.request.url, pathURL)
    }
    
    func testRequest_HTTPMethod_DefaultSession() {
        // Given
        let get = EndPointMock.test(httpMethod: .get)
        let post = EndPointMock.test(httpMethod: .post)
        let put = EndPointMock.test(httpMethod: .put)
        let delete = EndPointMock.test(httpMethod: .delete)
        let patch = EndPointMock.test(httpMethod: .patch)
        
        // When
        let getReq = defaultSession.request(endPoint: get)
        let postReq = defaultSession.request(endPoint: post)
        let putReq = defaultSession.request(endPoint: put)
        let deleteReq = defaultSession.request(endPoint: delete)
        let patchReq = defaultSession.request(endPoint: patch)
        
        // Then
        XCTAssertEqual(getReq.request.httpMethod, "GET")
        XCTAssertEqual(postReq.request.httpMethod, "POST")
        XCTAssertEqual(putReq.request.httpMethod, "PUT")
        XCTAssertEqual(deleteReq.request.httpMethod, "DELETE")
        XCTAssertEqual(patchReq.request.httpMethod, "PATCH")
    }
    
    func testRequest_HTTPTask_CodableData_isExist_DefaultSession() {
        // Given
        let encoder = JSONEncoder()
        let mockData = try? encoder.encode(codableMock)
        let bodyEp = EndPointMock.test(httpTask: (mockData, nil))
        
        // When
        let req = defaultSession.request(endPoint: bodyEp)
        
        // Then
        XCTAssertNotNil(req.request.httpBody)
    }
    
    func testRequest_HTTPTask_CodableData_whenNil_DefaultSession() {
        // Given
        let bodyEp = EndPointMock.test(httpTask: (nil, nil))
        
        // When
        let req = defaultSession.request(endPoint: bodyEp)
        
        // Then
        XCTAssertNil(req.request.httpBody)
    }
    
    func testRequest_HTTPTask_CodableData_whenDecode_success_DefaultSession() {
        // Given
        let encoder = JSONEncoder()
        let mockData = try? encoder.encode(codableMock)
        let bodyEp = EndPointMock.test(httpTask: (mockData, nil))
        
        // When
        let req = defaultSession.request(endPoint: bodyEp)
        let bodyData = req.request.httpBody!
        let decoder = JSONDecoder()
        let origin = try! decoder.decode(CodableMock.self, from: bodyData)
        
        // Then
        XCTAssertEqual(origin, codableMock)
    }
    
    func testRequest_HTTPTask_CodableData_whenDecode_fail_DefaultSession() {
        // Given
        let encoder = JSONEncoder()
        let mockData = try? encoder.encode(codableMock)
        let bodyEp = EndPointMock.test(httpTask: (mockData, nil))
        
        // When
        let req = defaultSession.request(endPoint: bodyEp)
        let bodyData = req.request.httpBody!
        let decoder = JSONDecoder()
        let origin = try! decoder.decode(CodableMock.self, from: bodyData)
        let failMock = CodableMock(name: "halgoraeDO", age: 20)
        
        // Then
        XCTAssertNotEqual(origin, failMock)
    }
    
    func testRequest_HTTPTask_JSONSerializeData_whenDecode_success_DefaultSession() {
        // Given
        let mockJson: [String: Any] = ["name": codableMock.name, "age": codableMock.age]
        let mockData = try? JSONSerialization.data(withJSONObject: mockJson, options: .prettyPrinted)
        let bodyEp = EndPointMock.test(httpTask: (mockData, nil))
        
        // When
        let req = defaultSession.request(endPoint: bodyEp)
        let bodyData = req.request.httpBody!
        let origin = try! JSONDecoder().decode(CodableMock.self, from: bodyData)
        
        // Then
        XCTAssertEqual(origin, codableMock)
    }
    
    func testRequest_HTTPTask_query_onlyBaseURL_DefaultSession() {
        // Given
        let baseURL = "https://base.com"
        let key = "name"
        let value = "woongs"
        let queries: Parameters = [key: value]
        let bodyEp = EndPointMock.test(baseURL: baseURL, httpTask: (nil, queries))
        
        // When
        let req = defaultSession.request(endPoint: bodyEp)
        let result = "\(baseURL)?\(key)=\(value)"
        
        // Then
        XCTAssertEqual(req.request.url?.absoluteString, result)
    }
    
    func testRequest_HTTPTask_query_withPath_DefaultSession() {
        // Given
        let baseURL = "https://base.com"
        let path = "main"
        let key = "name"
        let value = "woongs"
        let queries: Parameters = [key: value]
        let bodyEp = EndPointMock.test(baseURL: baseURL, path: path, httpTask: (nil, queries))
        
        // When
        let req = defaultSession.request(endPoint: bodyEp)
        let result = "\(baseURL)/\(path)?\(key)=\(value)"
        
        // Then
        XCTAssertEqual(req.request.url?.absoluteString, result)
    }
    
    func testRequest_HTTPHeaders_DefaultSession() {
        // Given
        let mockHeaders: [String: String] = ["Authorization": "token tttt", "Content-Type": "application/json"]
        let bodyEp = EndPointMock.test(headers: mockHeaders)
        
        // When
        let req = defaultSession.request(endPoint: bodyEp)
        
        // Then
        XCTAssertEqual(req.request.allHTTPHeaderFields, mockHeaders)
    }
}
