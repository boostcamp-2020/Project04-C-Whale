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
        switch self {
            case .one: return "우선순위 1"
            case .two: return "우선순위 2"
            case .three: return "우선순위 3"
            case .four: return "우선순위 4"
        }
    }
}
