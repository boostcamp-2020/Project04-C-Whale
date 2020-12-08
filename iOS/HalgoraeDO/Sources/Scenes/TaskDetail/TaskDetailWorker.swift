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
    
    func fetch(endPoint: TaskEndPoint, completion: @escaping (Task) -> Void) {
        
        networkManager.fetchData(endPoint) { (task: Task?, error) in
            
        }
    }
}
