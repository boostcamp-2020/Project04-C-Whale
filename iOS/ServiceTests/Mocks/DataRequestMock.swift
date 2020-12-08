//
//  DataRequestMock.swift
//  ServiceTests
//
//  Created by woong on 2020/12/06.
//

import Foundation

class DataRequestMock: DataResponsing {
    
    enum NetworkResponse: String {
        case success
        case badURL = "Bad URL"
        case authenticationError = "You need to be authenticated first."
        case badRequest = "Bad request"
        case outdated = "The url you requested is outdated."
        case failed = "Network request failed."
        case noData = "Response returned with no data to decode."
        case unableToDecode = "We could not decode the response."
    }
    
    var mockData: Data?
    var mockURL: URL?
    var response: NetworkResponse?
    
    init(mockData: Data? = nil, mockURL: URL? = nil, response: NetworkResponse? = nil) {
        self.mockData = mockData
        self.mockURL = mockURL
        self.response = response
    }
    
    func responseData(completionHandler: @escaping (Data?, NetworkResponse?) -> Void) -> Self {
        completionHandler(mockData, response)
        return self
    }
    
    func responseURL(completionHandler: @escaping (URL?, NetworkResponse?) -> Void) -> Self {
        completionHandler(mockURL, response)
        return self
    }
}
