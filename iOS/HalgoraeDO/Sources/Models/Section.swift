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
    var createdAt: String
    var updatedAt: String
    var tasks: [Task]?
}
