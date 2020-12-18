//
//  CodableMock.swift
//  ServiceTests
//
//  Created by woong on 2020/12/06.
//

import Foundation

struct CodableMock: Codable, Equatable {
    var name: String
    var age: Int
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name && lhs.age == rhs.age
    }
}
