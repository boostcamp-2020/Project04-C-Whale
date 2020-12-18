//
//  RequestTests.swift
//  ServiceTests
//
//  Created by woong on 2020/12/06.
//

import XCTest

class RequestTests: XCTestCase {
    
    var session: URLSession!
    var url: URL!
    var request: URLRequest!
    
    override func setUpWithError() throws {
        session = URLSession(configuration: .default)
        url = URL(string: "https://baseURL.com")!
        request = URLRequest(url: url)
    }
    
    func testURL_init_url() {
        // When
        let dataRequest = DataRequest(session: session, request: request)
        
        // Then
        XCTAssertEqual(dataRequest.request.url, url)
    }
    
    func testURL_inResponseData_success() {
        // Given
        let dataRequest = DataRequest(session: session, request: request)
        
        // When
        let responseRequest = dataRequest.responseData { (_, _) in }
        
        // Then
        XCTAssertEqual(responseRequest.request.url, url)
    }
    
    func testURL_inResponseData_withRootSlash_fail() {
        // Given
        let dataRequest = DataRequest(session: session, request: request)
        
        // When
        let responseRequest = dataRequest.responseData { (_, _) in }
        
        // Then
        XCTAssertNotEqual(responseRequest.request.url, URL(string: "https://baseURL.com/")!)
    }
    
    func testURL_inResponseData_withBadURL_fail() {
        // Given
        request.url = URL(string: "http://baseURL")!
        let dataRequest = DataRequest(session: session, request: request)
        
        // When
        let _ = dataRequest.responseData { (_, error) in
            // Then
            XCTAssertEqual(error, DataRequest.NetworkResponse.failed.rawValue)
        }
    }
    
    func testURL_inResponseURL_success() {
        // Given
        let dataRequest = DataRequest(session: session, request: request)
        
        // When
        let responseRequest = dataRequest.responseURL { (_, _) in }
        
        // Then
        XCTAssertEqual(responseRequest.request.url, url)
    }
}
