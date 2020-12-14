//
//  Bookmark+CoreDataProperties.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/13.
//
//

import Foundation
import CoreData


extension Bookmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bookmark> {
        return NSFetchRequest<Bookmark>(entityName: "Bookmark")
    }

    @NSManaged public var id: String
    @NSManaged public var url: String?
    @NSManaged public var task: Task?

}

extension Bookmark : Identifiable {

}
