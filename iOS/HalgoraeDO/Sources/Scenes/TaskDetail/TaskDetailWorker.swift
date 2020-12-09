//
//  TaskDetailWorker.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/01.
//

import Foundation


class TaskDetailWorker {
    
    let networkManager: NetworkDispatcher
    
    init(sessionManager: SessionManagerProtocol) {
        networkManager = NetworkManager(sessionManager: sessionManager)
    }
    
    func request<T: Decodable>(endPoint: TaskEndPoint, completion: @escaping ((T?, NetworkError?) -> Void)) {
        networkManager.fetchData(endPoint) { (result: T?, error: NetworkError?) in
            completion(result, error)
        }
    }
}
