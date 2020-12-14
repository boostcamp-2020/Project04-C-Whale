//
//  Project+CoreDataClass.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/13.
//
//

import Foundation
import CoreData

@objc(Project)
public class Project: NSManagedObject, Codable {
    
    convenience init(fields: MenuModels.ProjectFields, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID().uuidString
        
        configure(fields: fields)
    }
    
    func configure(fields: MenuModels.ProjectFields) {
        self.title = fields.title
        self.color = fields.color
        self.isFavorite = fields.isFavorite
        self.isList = fields.isList
    }

    required convenience public init(from decoder: Decoder) throws {
        self.init(context: Storage().childContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.color = try container.decodeIfPresent(String.self, forKey: .color)
        self.taskCount = try container.decodeIfPresent(Int32.self, forKey: .taskCount) ?? 0
        self.isList = try container.decode(Bool.self, forKey: .isList)
        self.isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
        let tempSections = try container.decode([Section].self, forKey: .sections)
        self.sections = NSOrderedSet(array: tempSections)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(color, forKey: .color)
        try container.encode(taskCount, forKey: .taskCount)
        try container.encode(isList, forKey: .isList)
        try container.encode(isFavorite, forKey: .isFavorite)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case color
        case taskCount
        case isList
        case isFavorite
        case sections
    }
}
