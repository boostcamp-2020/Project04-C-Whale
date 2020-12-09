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
    
    func request<T: Decodable>(endPoint: ProjectEndPoint, completion: @escaping ((T?, NetworkError?) -> Void)) {
        networkManager.fetchData(endPoint) { (result: T?, error: NetworkError?) in
            completion(result, error)
        }
    }
    
    // func fetchTasks(End)
    
    func changeFinish(task: Task, postion: Int, parentPosition: Int?) {
        
    }
}
