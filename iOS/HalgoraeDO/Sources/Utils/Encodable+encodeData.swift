//
//  Encodable+encodeData.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/13.
//

import Foundation

extension Encodable {
    
    var encodeData: Data? {
        return try? JSONEncoder().encode(self)
    }
}
