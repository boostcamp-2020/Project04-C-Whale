//
//  ResponseProject.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/10.
//

import Foundation

struct ResponseProject<T: Decodable>: Decodable {
    var project: T?
    var projectInfos: T?
}
