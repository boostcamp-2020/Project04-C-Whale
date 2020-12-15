//
//  TaskListWorker.swift
//  HalgoraeDO
//
//  Created by woong on 2020/11/23.
//

import Foundation

class TaskListWorker {
    
    let networkManager: NetworkDispatcher
    
    init(sessionManager: SessionManagerProtocol) {
        networkManager = NetworkManager(sessionManager: sessionManager)
    }
    
    func request<T: Decodable>(endPoint: EndPointType, completion: @escaping ((T?) -> Void)) {
        networkManager.fetchData(endPoint) { (response: T?, error: NetworkError?) in
            guard error == nil else {
                #if DEBUG
                print(error ?? "error is null")
                #endif
                completion(nil)
                return
            }
            completion(response)
        }
    }
    
    func requestPostAndGetTask<T: Decodable>(post postEndPoint: EndPointType, endPoint: ProjectEndPoint, completion: @escaping (T?) -> Void) {
        networkManager.fetchData(postEndPoint) { [weak self] (message: Response<String>?, error) in
            guard error == nil else {
                #if DEBUG
                print(error ?? "error is null")
                #endif
                completion(nil)
                return
            }
            self?.networkManager.fetchData(endPoint) { (response: T?, error: NetworkError?) in
                guard error == nil else {
                    #if DEBUG
                    print(error ?? "error is null")
                    #endif
                    completion(nil)
                    return
                }
                completion(response)
            }
        }
    }
}
