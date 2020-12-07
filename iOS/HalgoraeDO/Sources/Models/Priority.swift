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
