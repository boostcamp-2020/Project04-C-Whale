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
        networkManager.fetchData(endPoint) { (result: ResponseProject<T>?, error: NetworkError?) in
            guard error == nil else {
                #if DEBUG
                print(error ?? "error is null")
                #endif
                completion(nil)
                return
            }
            completion(result?.projectInfos)
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
            self?.networkManager.fetchData(getEndPoint) { (result: ResponseProject<T>?, error) in
                guard error == nil else {
                    #if DEBUG
                    print("response msg: \(String(describing: response))")
                    print(error ?? "error is null")
                    #endif
                    completion(nil)
                    return
                }
                completion(result?.projectInfos)
            }
        }
    }
}
