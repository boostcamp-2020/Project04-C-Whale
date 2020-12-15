//
//  Response.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/15.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    var message: String?
    var project: T?
    var projectInfos: T?
    var comments: T?
    var bookmarks: T?
    
    init(message: String? = nil,
        project: T? = nil,
        projectInfos: T? = nil,
        comments: T? = nil) {
        self.message = message
        self.project = project
        self.projectInfos = projectInfos
        self.comments = comments
    }
}
