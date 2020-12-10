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
    
    func request<T: Decodable>(endPoint: ProjectEndPoint, completion: @escaping (T?) -> Void) {
        
        if case ProjectEndPoint.create(_) = endPoint {
            requestCreate(endPoint: endPoint) { (result: T?) in
                completion(result)
            }
            return
        }
        
        networkManager.fetchData(endPoint) { (result: T?, error: NetworkError?) in
            guard error == nil else {
                #if DEBUG
                print(error ?? "error is null")
                #endif
                completion(nil)
                return
            }
            completion(result)
        }
    }
    
    private func requestCreate<T: Decodable>(endPoint: ProjectEndPoint, completion: @escaping ((T?) -> Void)) {
        networkManager.fetchData(endPoint) { [weak self] (response: ResponseMessage?, error) in
            guard error == nil else {
                #if DEBUG
                print("response msg: \(String(describing: response))")
                print(error ?? "error is null")
                #endif
                completion(nil)
                return
            }
            self?.networkManager.fetchData(ProjectEndPoint.getAll) { (result: T?, error) in
                completion(result)
            }
        }
    }
}
