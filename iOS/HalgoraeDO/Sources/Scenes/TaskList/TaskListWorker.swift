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
    
    func request<T: Decodable>(endPoint: ProjectEndPoint, completion: @escaping ((T?) -> Void)) {
        networkManager.fetchData(endPoint) { (result: ResponseProject<T>?, error: NetworkError?) in
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
    
    func requestPostAndGet<T: Decodable>(post postEndPoint: EndPointType, get getEndPoint: EndPointType, completion: @escaping (T?) -> Void) {
        networkManager.fetchData(postEndPoint) { [weak self] (response: ResponseMessage?, error) in
            guard error == nil else {
                #if DEBUG
                print("response msg: \(String(describing: response))")
                print(error ?? "error is null")
                #endif
                completion(nil)
                return
            }
            self?.networkManager.fetchData(getEndPoint) { (result: T?, error) in
                completion(result)
            }
        }
    }
    
    // func fetchTasks(End)
    
    func changeFinish(task: Task, postion: Int, parentPosition: Int?) {
        
    }
}
