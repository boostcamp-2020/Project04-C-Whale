//
//  MenuWorker.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/08.
//

import Foundation

class MenuWorker {
    
    let networkManager: NetworkDispatcher
    let storage: ProjectStorageType
    private var networkAvailable: Bool {
        return NetworkMonitor.shared.isAvailable
    }
    
    init(sessionManager: SessionManagerProtocol, storage: ProjectStorageType) {
        self.networkManager = NetworkManager(sessionManager: sessionManager)
        self.storage = storage
    }
    
    func request<T: Decodable>(endPoint: ProjectEndPoint, completion: @escaping (T?) -> Void) {
        guard networkAvailable else {
            requestStorage(endPoint: endPoint, completion: completion)
            return
        }
        
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
    
    func requestPostAndGet<T: Decodable>(post postEndPoint: ProjectEndPoint, get getEndPoint: EndPointType, completion: @escaping (T?) -> Void) {
        guard networkAvailable else {
            requestStorage(endPoint: postEndPoint, completion: completion)
            return
        }
        
        networkManager.fetchData(postEndPoint) { [weak self] (message: Response<String>?, error) in
            guard error == nil else {
                #if DEBUG
                print(error ?? "error is null")
                #endif
                completion(nil)
                return
            }
            self?.networkManager.fetchData(getEndPoint) { (response: T?, error) in
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
    
    func updateProjects(_ projects: [Project]) {
        guard networkAvailable else { return }
        storage.updateProjects(to: projects)
    }
    
    func requestStorage<T: Decodable>(endPoint: ProjectEndPoint, completion: @escaping (T?) -> Void) {
        switch endPoint {
            case .create(let data):
                guard let projectFields = try? JSONDecoder().decode(MenuModels.ProjectFields.self, from: data) else { return }
                storage.createProject(for: projectFields)
                storage.saveEndPoint(endPoint)
                storage.fetchProjectList { (response, error) in
                    guard error == nil else {
                        #if DEBUG
                        print("fetch fail from storage, \(error!)")
                        #endif
                        completion(nil)
                        return
                    }
                    completion(response as? T ?? nil)
                }
            case .delete(let id):
                storage.deleteProject(id: id)
                storage.saveEndPoint(endPoint)
            case .get(let projectId):
                let project = storage.fetchProject(id: projectId)
                completion(project as? T ?? nil)
            case .getAll:
                storage.fetchProjectList { (response, error) in
                    guard error == nil else {
                        #if DEBUG
                        print("fetch fail from storage, \(error!)")
                        #endif
                        completion(nil)
                        return
                    }
                    completion(response as? T ?? nil)
                }
            case .update(let id, let data):
                guard let projectFields = try? JSONDecoder().decode(MenuModels.ProjectFields.self, from: data) else { return }
                storage.updateProject(id: id, for: projectFields)
                storage.saveEndPoint(endPoint)
                storage.fetchProjectList { (response, error) in
                    guard error == nil else {
                        #if DEBUG
                        print("fetch fail from storage, \(error!)")
                        #endif
                        completion(nil)
                        return
                    }
                    completion(response as? T ?? nil)
                }
            default: break
        }
    }
}
