//
//  Date+.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/02.
//

import Foundation

extension Date {
    
    func toString(format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        
        return df.string(from: self)
    }
}
