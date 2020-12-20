//
//  Date+.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/02.
//

import Foundation

extension Date {
    
    mutating func fromString(format time: String = "yyyy-MM-dd hh:mm:ss") {
        let df = DateFormatter()
        df.dateFormat = time
        self = df.date(from: time) ?? Date()
    }
    
    func toString(format: String = "yyyy-MM-dd hh:mm:ss") -> String {
        let df = DateFormatter()
        df.dateFormat = format
        
        return df.string(from: self)
    }
}
