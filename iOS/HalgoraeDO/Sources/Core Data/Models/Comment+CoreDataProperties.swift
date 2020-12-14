//
//  Comment+CoreDataProperties.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/13.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var content: String?
    @NSManaged public var id: String
    @NSManaged public var task: Task?

}

extension Comment : Identifiable {

}
