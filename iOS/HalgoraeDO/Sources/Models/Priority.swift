//
//  Priority.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/26.
//

import Foundation

enum Priority: Int, CaseIterable {
    
    case one = 1
    case two
    case three
    case four
    
    var title: String {
        return "우선순위 \(self.rawValue)"
    }
}

extension Priority: Codable {
    enum CodingKeys: String, CodingKey {
        case title
    }
    
    init(from decoder: Decoder) throws {
        let title = try? decoder.container(keyedBy: CodingKeys.self).decode(String.self, forKey: .title)
        if let number = title?.last,
            let rawValue = Int("\(number)"),
           let priority = Priority(rawValue: rawValue) {
            self = priority
        } else {
            self = .four
        }
    }
}
