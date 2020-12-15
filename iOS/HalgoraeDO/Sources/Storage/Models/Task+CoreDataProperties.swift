//
//  Task+CoreDataProperties.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/13.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var createdAt: String?
    @NSManaged public var dueDate: String?
    @NSManaged public var id: String
    @NSManaged public var isDone: Bool
    @NSManaged public var position: Int16
    @NSManaged public var priorityRaw: Int16
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var bookmarks: NSOrderedSet?
    @NSManaged public var section: Section?
    @NSManaged public var tasks: NSOrderedSet?
    @NSManaged public var comments: NSOrderedSet?

}

// MARK: Generated accessors for bookmarks
extension Task {

    @objc(insertObject:inBookmarksAtIndex:)
    @NSManaged public func insertIntoBookmarks(_ value: Bookmark, at idx: Int)

    @objc(removeObjectFromBookmarksAtIndex:)
    @NSManaged public func removeFromBookmarks(at idx: Int)

    @objc(insertBookmarks:atIndexes:)
    @NSManaged public func insertIntoBookmarks(_ values: [Bookmark], at indexes: NSIndexSet)

    @objc(removeBookmarksAtIndexes:)
    @NSManaged public func removeFromBookmarks(at indexes: NSIndexSet)

    @objc(replaceObjectInBookmarksAtIndex:withObject:)
    @NSManaged public func replaceBookmarks(at idx: Int, with value: Bookmark)

    @objc(replaceBookmarksAtIndexes:withBookmarks:)
    @NSManaged public func replaceBookmarks(at indexes: NSIndexSet, with values: [Bookmark])

    @objc(addBookmarksObject:)
    @NSManaged public func addToBookmarks(_ value: Bookmark)

    @objc(removeBookmarksObject:)
    @NSManaged public func removeFromBookmarks(_ value: Bookmark)

    @objc(addBookmarks:)
    @NSManaged public func addToBookmarks(_ values: NSOrderedSet)

    @objc(removeBookmarks:)
    @NSManaged public func removeFromBookmarks(_ values: NSOrderedSet)

}

// MARK: Generated accessors for tasks
extension Task {

    @objc(insertObject:inTasksAtIndex:)
    @NSManaged public func insertIntoTasks(_ value: Task, at idx: Int)

    @objc(removeObjectFromTasksAtIndex:)
    @NSManaged public func removeFromTasks(at idx: Int)

    @objc(insertTasks:atIndexes:)
    @NSManaged public func insertIntoTasks(_ values: [Task], at indexes: NSIndexSet)

    @objc(removeTasksAtIndexes:)
    @NSManaged public func removeFromTasks(at indexes: NSIndexSet)

    @objc(replaceObjectInTasksAtIndex:withObject:)
    @NSManaged public func replaceTasks(at idx: Int, with value: Task)

    @objc(replaceTasksAtIndexes:withTasks:)
    @NSManaged public func replaceTasks(at indexes: NSIndexSet, with values: [Task])

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSOrderedSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSOrderedSet)

}

// MARK: Generated accessors for comments
extension Task {

    @objc(insertObject:inCommentsAtIndex:)
    @NSManaged public func insertIntoComments(_ value: Comment, at idx: Int)

    @objc(removeObjectFromCommentsAtIndex:)
    @NSManaged public func removeFromComments(at idx: Int)

    @objc(insertComments:atIndexes:)
    @NSManaged public func insertIntoComments(_ values: [Comment], at indexes: NSIndexSet)

    @objc(removeCommentsAtIndexes:)
    @NSManaged public func removeFromComments(at indexes: NSIndexSet)

    @objc(replaceObjectInCommentsAtIndex:withObject:)
    @NSManaged public func replaceComments(at idx: Int, with value: Comment)

    @objc(replaceCommentsAtIndexes:withComments:)
    @NSManaged public func replaceComments(at indexes: NSIndexSet, with values: [Comment])

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: Comment)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: Comment)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSOrderedSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSOrderedSet)

}

extension Task : Identifiable {

}
