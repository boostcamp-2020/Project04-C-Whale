//
//  AuthManager.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/16.
//

import Foundation

class AuthManager {
    static let shared: AuthManager = AuthManager()
    private let tokenKey = "userToken"
    
    var userToken: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: tokenKey)
        }
    }
}
