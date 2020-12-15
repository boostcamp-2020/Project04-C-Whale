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
    
    func requestPostAndGet<T: Decodable>(post postEndPoint: EndPointType, get getEndPoint: EndPointType, completion: @escaping (T?) -> Void) {
        networkManager.fetchData(postEndPoint) { [weak self] (message: Response<String>?, error) in
            guard error == nil else {
                #if DEBUG
                print("response msg: \(String(describing: message))")
                print(error ?? "error is null")
                #endif
                completion(nil)
                return
            }
            self?.networkManager.fetchData(getEndPoint) { (response: Response<T>?, error: NetworkError?) in
                guard error == nil else {
                    #if DEBUG
                    print(error ?? "error is null")
                    #endif
                    completion(nil)
                    return
                }
                completion(response?.comments)
            }
        }
    }
}
