//
//  DataRequest.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/04.
//

import Foundation

protocol DataResponsing {
    
    associatedtype NetworkResponse
    
    @discardableResult
    func responseData(completionHandler: @escaping (Data?, NetworkResponse?) -> Void) -> Self
    @discardableResult
    func responseURL(completionHandler: @escaping (URL?, NetworkResponse?) -> Void) -> Self
}

class DataRequest {
    
    // MARK: - Constants
    
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
    
    // MARK: - Properties
    
    let session: URLSession
    private(set) var request: URLRequest
    
    init(session: URLSession, request: URLRequest) {
        self.session = session
        self.request = request
    }
}

extension DataRequest: DataResponsing {
    
    @discardableResult
    func responseData(completionHandler: @escaping (Data?, NetworkResponse?) -> Void) -> Self {
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard error == nil else {
                completionHandler(nil, .failed)
                return
            }

            guard let data = data else {
                completionHandler(nil, .noData)
                return
            }
            
            completionHandler(data, .success)
        }).resume()
        
        return self
    }
    
    @discardableResult
    func responseURL(completionHandler: @escaping (URL?, NetworkResponse?) -> Void) -> Self {
        session.downloadTask(with: request) { (url, response, error) in
            guard error == nil else {
                completionHandler(nil, .failed)
                return
            }

            guard let url = url else {
                completionHandler(nil, .noData)
                return
            }
            
            completionHandler(url, .success)
        }.resume()
        
        return self
    }
}
