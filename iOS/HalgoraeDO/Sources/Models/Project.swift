//
//  Project.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/08.
//

import Foundation

class Project: Codable {
    var id: String?
    var title: String
    var taskCount: Int
    var isFavorite: Bool?
    var isList: Bool?
    var sections: [Section]?
}

extension Project: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id
    }
}
