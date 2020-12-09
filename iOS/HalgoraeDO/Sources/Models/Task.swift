//
//  Task.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import Foundation

final class Task {

    // MARK:  - Constatns
    
    var id: String = UUID().uuidString
    
    // MARK: - Properties
    
    var tasks: [Task]?
    weak var parent: Task?
    var title: String
    var isDone: Bool
    var dueDate: String
    var position: Int
    var createdAt: String
    var updatedAt: String
    var priority: Priority?
    var comments: [Comment]?
    var bookmarks: [Bookmark]?
    
    init(section: String = "",
         title: String,
         isCompleted: Bool = false,
         dueDate: String = "\(Date())",
         position: Int,
         createdAt: String = "\(Date())",
         updatedAt: String = "\(Date())",
         priority: Priority = .four,
         parent: Task? = nil,
         subTasks: [Task] = [],
         comments: [Comment] = [],
         bookmarks: [Bookmark] = []
    ) {
        
        self.title = title
        self.isDone = isCompleted
        self.dueDate = dueDate
        self.position = position
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.priority = priority
        self.parent = parent
        self.tasks = subTasks
        self.comments = comments
        self.bookmarks = bookmarks
        self.tasks?.forEach { $0.parent = self }
    }
        
    // MARK: - Methods
    
    // MARK: Mutable
    
    func insert(_ task: Task, at index: Int) {
        guard var tasks = task.tasks else { return }
        assert(!(0..<tasks.count ~= index), "Out of Index")
        task.parent = self
        tasks.insert(task, at: index)
    }
    
    func append(_ task: Task) {
        guard var tasks = task.tasks else { return }
        task.parent = self
        tasks.append(task)
        self.tasks = tasks
    }
    
    @discardableResult
    func remove(_ task: Task) -> Task? {
        guard var tasks = task.tasks else { return nil }
        guard let index = tasks.firstIndex(of: task) else { return nil }
        tasks[index].parent = nil
        return tasks.remove(at: index)
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
        return "id: \(id), title: \(title), isCompleted: \(isDone), parent: \(parent ?? "nil" as CustomStringConvertible), subTasks: \(tasks)"
    }
}
