//
//  Task.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import Foundation

class Task {
    
    // MARK: - Properties
    
    let identifier = UUID()
    var section: String
    var title: String
    var isCompleted: Bool
    var priority: Priority
    weak var parent: Task?
    private(set) var subTasks: [Task]
    
    init(section: String = "",
         title: String,
         isCompleted: Bool = false,
         priority: Priority = .four,
         parent: Task? = nil,
         subTasks: [Task] = []) {
        
        self.section = section
        self.title = title
        self.isCompleted = isCompleted
        self.parent = parent
        self.priority = priority
        self.subTasks = subTasks
        self.subTasks.forEach { $0.parent = self }
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

// MARK: - Hashable

extension Task: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Task, rhs: Task) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

// MARK:  - CustomStringConvertible

extension Task: CustomStringConvertible {
    var description: String {
        return "id: \(identifier), title: \(title), isCompleted: \(isCompleted), parent: \(parent ?? "nil" as CustomStringConvertible), subTasks: \(subTasks)"
    }
}
