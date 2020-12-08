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
    
    func testRequest_request_init_url() {
        // When
        let dataRequest = DataRequest(session: session, request: request)
        
        // Then
        XCTAssertEqual(dataRequest.request.url, url)
    }
    
    func testRequest_responseData_init_url() {
        // Given
        let dataRequest = DataRequest(session: session, request: request)
        
        // When
        let responseRequest = dataRequest.responseData { (_, _) in }
        
        // Then
        XCTAssertEqual(responseRequest.request.url, url)
    }
    
    func testRequest_responseURL_init_url() {
        // Given
        let dataRequest = DataRequest(session: session, request: request)
        
        // When
        let responseRequest = dataRequest.responseURL { (_, _) in }
        
        // Then
        XCTAssertEqual(responseRequest.request.url, url)
    }
}
