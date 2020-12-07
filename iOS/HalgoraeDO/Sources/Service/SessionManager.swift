//
//  SessionManager.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/04.
//

import Foundation

protocol SessionManagerProtocol {
    
    associatedtype Request: DataResponsing
    
    func request(endPoint: EndPointType,
                 cachePolicy: URLRequest.CachePolicy,
                 timeoutInterval: TimeInterval) -> Request
}

extension SessionManagerProtocol {
    func request(endPoint: EndPointType,
                 cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData,
                 timeoutInterval: TimeInterval = 10.0) -> Request {
        request(endPoint: endPoint, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
}

class SessionManager: SessionManagerProtocol {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration, delegate: URLSessionDelegate? = nil, delegateQueue: OperationQueue? = nil) {
        self.session = .init(configuration: configuration, delegate: delegate, delegateQueue: delegateQueue)
    }
    
    func request(endPoint: EndPointType,
                 cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData,
                 timeoutInterval: TimeInterval = 10.0) -> DataRequest {
        var url = endPoint.baseURL
        if !endPoint.path.isEmpty {
            url.appendPathComponent(endPoint.path)
        }

        var request = URLRequest(url: url,
                                 cachePolicy: cachePolicy,
                                 timeoutInterval: timeoutInterval)
        request.httpMethod = endPoint.httpMethod.rawValue
        request.allHTTPHeaderFields = endPoint.headers
        
        let (body, queryItems) = endPoint.httpTask
        request.httpBody = body
        
        if let queryItems = queryItems {
            do {
                try URLParameterEncoder().encode(urlRequest: &request, with: queryItems)
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
        }
        
        if let headers = endPoint.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return DataRequest(session: session, request: request)
    }
}
