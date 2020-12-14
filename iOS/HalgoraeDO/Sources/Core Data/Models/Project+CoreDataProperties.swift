//
//  Project+CoreDataProperties.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/13.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var id: String
    @NSManaged public var isList: Bool
    @NSManaged public var title: String?
    @NSManaged public var taskCount: Int32
    @NSManaged public var isFavorite: Bool
    @NSManaged public var color: String?
    @NSManaged public var sections: NSOrderedSet?

}

// MARK: Generated accessors for sections
extension Project {

    @objc(insertObject:inSectionsAtIndex:)
    @NSManaged public func insertIntoSections(_ value: Section, at idx: Int)

    @objc(removeObjectFromSectionsAtIndex:)
    @NSManaged public func removeFromSections(at idx: Int)

    @objc(insertSections:atIndexes:)
    @NSManaged public func insertIntoSections(_ values: [Section], at indexes: NSIndexSet)

    @objc(removeSectionsAtIndexes:)
    @NSManaged public func removeFromSections(at indexes: NSIndexSet)

    @objc(replaceObjectInSectionsAtIndex:withObject:)
    @NSManaged public func replaceSections(at idx: Int, with value: Section)

    @objc(replaceSectionsAtIndexes:withSections:)
    @NSManaged public func replaceSections(at indexes: NSIndexSet, with values: [Section])

    @objc(addSectionsObject:)
    @NSManaged public func addToSections(_ value: Section)

    @objc(removeSectionsObject:)
    @NSManaged public func removeFromSections(_ value: Section)

    @objc(addSections:)
    @NSManaged public func addToSections(_ values: NSOrderedSet)

    @objc(removeSections:)
    @NSManaged public func removeFromSections(_ values: NSOrderedSet)

}

extension Project : Identifiable {

}
