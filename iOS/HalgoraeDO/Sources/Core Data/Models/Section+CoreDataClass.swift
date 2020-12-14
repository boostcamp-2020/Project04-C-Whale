//
//  Section+CoreDataClass.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/13.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    // Helper property to retrieve the context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

@objc(Section)
public class Section: NSManagedObject, Codable {
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(context: Storage().childContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        let tempTasks = try container.decodeIfPresent([Task].self, forKey: .tasks)
        self.tasks = NSOrderedSet(array: tempTasks ?? [])
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case id
        case title
        case updatedAt
        case tasks
    }
}
