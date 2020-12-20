//
//  Comment+CoreDataClass.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/13.
//
//

import Foundation
import CoreData

@objc(Comment)
public class Comment: NSManagedObject, Codable {
    
    required convenience public init(from decoder: Decoder) throws {
        self.init(context: Storage().childContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.content = try container.decode(String.self, forKey: .content)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(content, forKey: .content)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case task
    }
}
