//
//  EndPointMO+CoreDataClass.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/13.
//
//

import Foundation
import CoreData

@objc(EndPointMO)
public class EndPointMO: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext, endPoint: EndPointType) {
        self.init(context: Storage().childContext)
        
        self.createdAt = Date()
        self.url = endPoint.baseURL
        self.path = endPoint.path
        self.httpMethod = endPoint.httpMethod.rawValue
        self.httpHeadersData = try? JSONSerialization.data(withJSONObject: endPoint.headers ?? [:], options: .prettyPrinted)
        self.body = endPoint.httpTask.body
        self.queryItemsData = try? JSONSerialization.data(withJSONObject: endPoint.httpTask.queryItems ?? [:], options: .prettyPrinted)
    }
    
    var httpHeaders: [String: String]? {
        guard let data = httpHeadersData else { return nil }
        return try? JSONDecoder().decode([String: String].self, from: data)
    }
    
    var queryItems: [String: Any]? {
        guard let data = queryItemsData else { return nil }
        let queryDecode =  try? JSONDecoder().decode(QueryDecode.self, from: data)
        return queryDecode?.value
    }
    
    var endPoint: DefaultEndPoint {
        return DefaultEndPoint(baseURL: url!,
                                path: path!,
                                httpMethod: HTTPMethod(rawValue: httpMethod!)!,
                                httpTask: HTTPTask(body, queryItems),
                                headers: httpHeaders)
    }
}

struct QueryDecode: Decodable {
    var value: [String: Any]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: JSONCodingKeys.self)
        self.value = try container.decode([String: Any].self)
    }
}


struct JSONCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?

    init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = Int(stringValue)
    }

    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

// MARK: - Decode

extension KeyedDecodingContainer {
    func decode(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any] {
        let container = try nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any]? {
        guard contains(key) else { return nil }
        return try decode(type, forKey: key)
    }

    func decode(_ type: [Any].Type, forKey key: K) throws -> [Any] {
        var container = try nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: [Any].Type, forKey key: K) throws -> [Any]? {
        guard contains(key) else { return nil }
        return try decode(type, forKey: key)
    }

    func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        var dictionary = [String: Any]()

        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode([String: Any].self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode([Any].self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}

extension UnkeyedDecodingContainer {
    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var array: [Any] = []

        while !isAtEnd {
            let value: String? = try decode(String?.self)
            guard value != nil else { continue }

            if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Int.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode([String: Any].self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode([Any].self) {
                array.append(nestedArray)
            }
        }
        return array
    }

    mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}
