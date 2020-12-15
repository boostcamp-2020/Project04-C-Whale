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
            let raw = Int(priorityRaw)
            return Priority(rawValue: raw) ?? .four
        }
        set {
            self.priorityRaw = Int16(newValue.rawValue)
        }
    }
    
    convenience init(fields: TaskListModels.TaskFields, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID().uuidString
        
        configure(fields: fields)
    }
    
    func configure(fields: TaskListModels.TaskFields) {
        self.title = fields.title
        self.priorityRaw = Int16(fields.priority) ?? 4
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
        self.parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
        let priorityString = try container.decode(String.self, forKey: .priorityRaw)
        self.priorityRaw = Int16(priorityString) ?? 4
        let tempBookmarks = try container.decodeIfPresent([Bookmark].self, forKey: .bookmarks)
        self.bookmarks = NSOrderedSet(array: tempBookmarks ?? [])
        let tempComments = try container.decodeIfPresent([Comment].self, forKey: .comments)
        self.comments = NSOrderedSet(array: tempComments ?? [])
        let tempTasks = try container.decodeIfPresent([Task].self, forKey: .tasks)
        self.tasks = NSOrderedSet(array: tempTasks ?? [])
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(dueDate, forKey: .dueDate)
        try container.encode(id, forKey: .id)
        try container.encode(isDone, forKey: .isDone)
        try container.encode(parentId, forKey: .parentId)
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
        case parentId
        case position
        case priorityRaw = "priority"
        case title
        case updatedAt
        case tasks
        case bookmarks
        case comments
    }
}
