//
//  EndPoint.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/03.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var httpTask: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

/// body와 queryItems
/// - body: encoding Data
/// - queryItems: [String: Any]
typealias HTTPTask = (body: Data?, queryItems: Parameters?)
typealias HTTPHeaders = [String: String]


