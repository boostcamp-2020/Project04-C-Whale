//
//  Comment.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/08.
//

import Foundation

struct Comment: Codable {
    var id: String = UUID().uuidString
    var contents: String
    var isImage: Bool = false
}
