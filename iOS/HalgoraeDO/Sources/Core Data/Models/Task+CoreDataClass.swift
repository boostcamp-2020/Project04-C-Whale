//
//  Task+CoreDataClass.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/13.
//
//

import Foundation
import CoreData

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

@objc(Task)
public class Task: NSManagedObject, Codable {
    
    var parent: Task?
    var priority: Priority {
        get {
            return Priority(rawValue: Int(priorityRaw)) ?? .four
        }
        set {
            self.priorityRaw = Int16(newValue.rawValue)
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(context: Storage().childContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.dueDate = try container.decodeIfPresent(String.self, forKey: .dueDate)
        self.position = try container.decode(Int16.self, forKey: .position)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        self.isDone = try container.decode(Bool.self, forKey: .isDone)
        let priorityString = try container.decode(String.self, forKey: .priorityRaw)
        self.priorityRaw = Int16(priorityString) ?? 4
//        self.bookmarks = container.decode(
//        self.comments = container.decode(
//        self.section = container.decode(
//        self.tasks = container.decode(
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(id, forKey: .id)
        try container.encode(isDone, forKey: .isDone)
        try container.encode(position, forKey: .position)
        try container.encode(priorityRaw, forKey: .priorityRaw)
        try container.encode(title, forKey: .title)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case dueDate
        case id
        case isDone
        case position
        case priorityRaw = "priority"
        case title
        case updatedAt
//        case bookmarks
//        case comments
//        case tasks
    }
}
