//
//  Section.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/08.
//

import Foundation

class Section: Codable {
    var id: String
    var title: String
    var createdAt: Date
    var updatedAt: Date
    var tasks: [Task]
}
