//
//  MenuWorker.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/08.
//

import Foundation

class MenuWorker {
    
    let networkManager: NetworkDispatcher
    
    init(sessionManager: SessionManagerProtocol) {
        networkManager = NetworkManager(sessionManager: sessionManager)
    }
    
    func request<T: Decodable>(endPoint: ProjectEndPoint, completion: @escaping ((T?, NetworkError?) -> Void)) {
        networkManager.fetchData(endPoint) { (result: T?, error: NetworkError?) in
            completion(result, error)
        }
    }
}
