//
//  DataRequestMock.swift
//  ServiceTests
//
//  Created by woong on 2020/12/06.
//

import Foundation

class DataRequestMock: DataResponsing {
    
    var session = URLSession(configuration: .default)
    var request = URLRequest(url: URL(string: "https://base.com")!)
    
    
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
    
    func responseData(completionHandler: @escaping (Data?, String?) -> Void) -> Self {
        completionHandler(mockData, response?.rawValue)
        return self
    }
    
    func responseURL(completionHandler: @escaping (URL?, String?) -> Void) -> Self {
        completionHandler(mockURL, response?.rawValue)
        return self
    }
}
