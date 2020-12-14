//
//  ResponseDetail.swift
//  HalgoraeDO
//
//  Created by 이상윤 on 2020/12/14.
//

import Foundation

struct ResponseDetail<T: Decodable>: Decodable {
    var comments: T?
}
