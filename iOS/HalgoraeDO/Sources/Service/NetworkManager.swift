//
//  NetworkService.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/03.
//

import Foundation

protocol NetworkDispatcher {
    associatedtype NetworkError
    
    func fetchData<T: Decodable>(_ endpoint: EndPointType, completion: @escaping (_ data: T?, _ error: NetworkError?) -> Void)
    func fetchDownload(_ endpoint: EndPointType, completion: @escaping (_ url: URL?, _ error: NetworkError?) -> Void)
}

class NetworkManager<Session: SessionManagerProtocol> {
    
    enum NetworkError: Error {
        case responseFail(Session.Request.NetworkResponse?)
        case unableToDecode(String?)
    }
    
    enum RequestType {
        case data
        case url
    }
    
    let sessionManager: Session
    
    init(sessionManager: Session) {
        self.sessionManager = sessionManager
    }
}

// MARK: - NetworkDispatcher

extension NetworkManager: NetworkDispatcher {
    
    func fetchData<T>(_ endpoint: EndPointType, completion: @escaping (_ data: T?, _ error: NetworkError?) -> Void) where T : Decodable {
        
        sessionManager.request(endPoint: endpoint).responseData { (result, response) in
            guard let result = result else {
                
                completion(nil, .responseFail(response))
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let result = try decoder.decode(T.self, from: result)
                completion(result, nil)
            } catch {
                completion(nil, .unableToDecode("Could not decode data"))
            }
        }
    }
    
    func fetchDownload(_ endpoint: EndPointType, completion: @escaping (_ url: URL?, _ error: NetworkError?) -> Void) {
        sessionManager.request(endPoint: endpoint).responseURL { (result, response) in
            guard let result = result else {
                completion(nil, .responseFail(response))
                return
            }
            completion(result, nil)
        }
    }
}
