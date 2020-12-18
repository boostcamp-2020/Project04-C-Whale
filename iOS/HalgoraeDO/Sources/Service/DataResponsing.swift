//
//  DataResponsing.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/17.
//

import Foundation

protocol DataResponsing {
    var session: URLSession { get }
    var request: URLRequest { get }
    @discardableResult
    func responseData(completionHandler: @escaping (Data?, String?) -> Void) -> Self
    @discardableResult
    func responseURL(completionHandler: @escaping (URL?, String?) -> Void) -> Self
}
