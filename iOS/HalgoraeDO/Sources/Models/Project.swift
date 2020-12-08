//
//  Project.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/08.
//

import Foundation

class Project: Codable {
    var id: UUID
    var title: String
    var taskCount: Int
    var isList: Bool
    var sections: [Section]
}
