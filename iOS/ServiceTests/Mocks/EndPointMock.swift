//
//  EndPointMock.swift
//  ServiceTests
//
//  Created by woong on 2020/12/06.
//

import Foundation

enum EndPointMock {
    case test(baseURL: String = "https://baseURL.com",
              path: String = "",
              httpMethod: HTTPMethod = .get,
              httpTask: HTTPTask = (nil, nil),
              headers: HTTPHeaders? = nil)
}


extension EndPointMock: EndPointType {
    var baseURL: URL {
        switch self {
            case .test(let baseURL, _, _, _, _): return URL(string: baseURL)!
        }
    }
    
    var path: String {
        switch self {
            case .test(_, let path, _, _, _): return path
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
            case .test(_, _, let method, _, _): return method
        }
    }
    
    var httpTask: HTTPTask {
        switch self {
            case .test(_, _, _, let task, _): return task
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
            case .test(_, _, _, _, let headers): return headers
        }
    }
}
