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
    
    func requestProjects<T: Decodable>(endPoint: ProjectEndPoint, completion: @escaping ((T?) -> Void)) {
        networkManager.fetchData(endPoint) { (result: Response<T>?, error: NetworkError?) in
            guard error == nil else {
                #if DEBUG
                print(error ?? "error is null")
                #endif
                completion(nil)
                return
            }
            completion(result?.project)
        }
    }
    
    func requestPatch<T: Decodable>(endPoint: EndPointType, completion: @escaping ((T?) -> Void)) {
        networkManager.fetchData(endPoint) { (message: Response<T>?, error) in
            guard error == nil else {
                #if DEBUG
                print(error ?? "error is null")
                #endif
                completion(nil)
                return
            }
            completion(message?.message)
        }
    }

    func requestPostAndGetTask<T: Decodable>(post postEndPoint: EndPointType, endPoint: ProjectEndPoint, completion: @escaping (T?) -> Void) {
        networkManager.fetchData(postEndPoint) { [weak self] (message: Response<String>?, error) in
            guard error == nil else {
                #if DEBUG
                print("response msg: \(String(describing: message))")
                print(error ?? "error is null")
                #endif
                completion(nil)
                return
            }
            self?.networkManager.fetchData(endPoint) { (result: Response<T>?, error: NetworkError?) in
                guard error == nil else {
                    #if DEBUG
                    print(error ?? "error is null")
                    #endif
                    completion(nil)
                    return
                }
                completion(result?.project)
            }
        }
    }
}
