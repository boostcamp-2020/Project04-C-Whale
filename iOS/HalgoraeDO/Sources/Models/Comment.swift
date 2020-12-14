//
//  Comment.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/08.
//

import Foundation

struct Comment: Codable {
    var id: String = UUID().uuidString
    var content: String
    var isImage: Bool? = false
    var createdAt: String
    var updatedAt: String
    var taskId: String
}
