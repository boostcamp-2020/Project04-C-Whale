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
    
    init(id: String = UUID().uuidString,
         title: String,
         createdAt: String = "\(Date())",
         updatedAt: String = "\(Date())",
         tasks: [Task] = []
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tasks = tasks
    }
}
