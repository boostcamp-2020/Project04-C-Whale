//
//  EndPointMO+CoreDataProperties.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/14.
//
//

import Foundation
import CoreData


extension EndPointMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EndPointMO> {
        return NSFetchRequest<EndPointMO>(entityName: "EndPointMO")
    }

    @NSManaged public var url: URL?
    @NSManaged public var path: String?
    @NSManaged public var httpMethod: String?
    @NSManaged public var httpHeadersData: Data?
    @NSManaged public var body: Data?
    @NSManaged public var queryItemsData: Data?
    @NSManaged public var createdAt: Date?
}

extension EndPointMO : Identifiable {

}
