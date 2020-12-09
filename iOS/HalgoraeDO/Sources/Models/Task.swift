//
//  Task.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import Foundation

final class Task {

    // MARK:  - Constatns
    
    let id: String = UUID().uuidString
    
    // MARK: - Properties
    
    private(set) var subTasks: [Task]
    weak var parent: Task?
    var section: String
    var title: String
    var isDone: Bool
    var dueDate: Date
    var createdAt: Date
    var updatedAt: Date
    var priority: Priority?
    var comments: [Comment]
    var bookmarks: [Bookmark]
    
    init(section: String = "",
         title: String,
         isCompleted: Bool = false,
         dueDate: Date = Date(),
         createdAt: Date = Date(),
         updatedAt: Date = Date(),
         priority: Priority = .four,
         parent: Task? = nil,
         subTasks: [Task] = [],
         comments: [Comment] = [],
         bookmarks: [Bookmark] = []
    ) {
        
        self.section = section
        self.title = title
        self.isDone = isCompleted
        self.dueDate = dueDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.priority = priority
        self.parent = parent
        self.subTasks = subTasks
        // self.subTasks.forEach { $0.parent = self }
        self.comments = comments
        self.bookmarks = bookmarks
    }
        
    // MARK: - Methods
    
    // MARK: Mutable
    
    func insert(_ task: Task, at index: Int) {
        assert(!(0..<subTasks.count ~= index), "Out of Index")
        task.parent = self
        subTasks.insert(task, at: index)
    }
    
    func append(_ task: Task) {
        task.parent = self
        self.subTasks.append(task)
    }
    
    @discardableResult
    func remove(_ task: Task) -> Task? {
        guard let index = subTasks.firstIndex(of: task) else { return nil }
        subTasks[index].parent = nil
        return subTasks.remove(at: index)
    }
}

extension Task: Codable {
    
}

// MARK: - Hashable

extension Task: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK:  - CustomStringConvertible

extension Task: CustomStringConvertible {
    var description: String {
        return "id: \(id), title: \(title), isCompleted: \(isDone), parent: \(parent ?? "nil" as CustomStringConvertible), subTasks: \(subTasks)"
    }
}
