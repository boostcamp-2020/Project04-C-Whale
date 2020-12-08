//
//  MenuModels.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/08.
//

import Foundation

enum MenuModels {
    

extension MenuModels {
    
    enum ProjectSection: Int, Hashable, CaseIterable, CustomStringConvertible {
        case normal = 0, project
        var description: String {
            switch self {
            case .normal: return ""
            case .project: return "프로젝트"
            }
        }
    }
    
    struct ProjectVM: Hashable {
        var id: String
        var title: String
        var color: String
        var taskCount: Int
        var isFavorite: Bool
        var isHeader: Bool = false
        
        init(id: String = UUID().uuidString,
            title: String = "",
            color: String = "#BDBDBD",
            taskCount: Int = 0,
            isFavorite: Bool = false,
            isHeader: Bool = false) {
            
            self.id = id
            self.title = title
            self.color = color
            self.taskCount = taskCount
            self.isFavorite = isFavorite
            self.isHeader = isHeader
        }
        
        init(project: Project, makeFavorite: Bool = false) {
            self.id = project.id ?? UUID().uuidString
            self.title = project.title
            self.color = "#BDBDBD"
            self.taskCount = project.taskCount
            self.isFavorite = project.isFavorite ?? false
            
            if makeFavorite {
                self.id += "+"
            }
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func ==(lhs: Self, rhs: Self) -> Bool {
            return lhs.id == rhs.id
        }
    }
}
