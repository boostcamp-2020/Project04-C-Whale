//
//  DefaultEndPoint.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/14.
//

import Foundation

struct DefaultEndPoint: EndPointType {
    var baseURL: URL
    var path: String
    var httpMethod: HTTPMethod
    var httpTask: HTTPTask
    var headers: HTTPHeaders?
}
