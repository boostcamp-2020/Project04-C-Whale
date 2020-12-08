//
//  SessionManagerMock.swift
//  ServiceTests
//
//  Created by woong on 2020/12/06.
//

import Foundation

class SessionManagerMock: SessionManagerProtocol {
    
    var request: DataRequestMock
    
    init(request: DataRequestMock) {
        self.request = request
    }
    
    func request(endPoint: EndPointType,
                 cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData,
                 timeoutInterval: TimeInterval = 10.0) -> DataRequestMock {
        
        return request
    }
}
