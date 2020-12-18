//
//  NetworkService.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/03.
//

import Foundation

protocol NetworkDispatcher {
    func fetchData<T: Decodable>(_ endpoint: EndPointType, completion: @escaping (_ data: T?, _ error: NetworkError?) -> Void)
    func fetchDownload(_ endpoint: EndPointType, completion: @escaping (_ url: URL?, _ error: NetworkError?) -> Void)
}

enum NetworkError: Error {
    case responseFail(String?)
    case unableToDecode(String?)
}

class NetworkManager {

    enum RequestType {
        case data
        case url
    }
    
    let sessionManager: SessionManagerProtocol
    
    init(sessionManager: SessionManagerProtocol) {
        self.sessionManager = sessionManager
    }
}

// MARK: - NetworkDispatcher

extension NetworkManager: NetworkDispatcher {

    func fetchData<T>(_ endpoint: EndPointType, completion: @escaping (_ data: T?, _ error: NetworkError?) -> Void) where T : Decodable {

        sessionManager.request(endPoint: endpoint,
                               cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                               timeoutInterval: 5).responseData { (data, response) in
                                
            guard let data = data else {
                completion(nil, .responseFail(response))
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let result = try decoder.decode(T.self, from: data)
                completion(result, nil)
            } catch {
                completion(nil, .unableToDecode("\(error)"))
            }
        }
    }

    func fetchDownload(_ endpoint: EndPointType, completion: @escaping (_ url: URL?, _ error: NetworkError?) -> Void) {
        sessionManager.request(endPoint: endpoint, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5).responseURL { (result, response) in
            guard let result = result else {
                completion(nil, .responseFail(response))
                return
            }
            completion(result, nil)
        }
    }
}
