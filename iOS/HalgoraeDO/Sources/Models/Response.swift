//
//  Response.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/15.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    var project: T?
    var projectInfos: T?
    var message: T?
    var comments: T?
}
