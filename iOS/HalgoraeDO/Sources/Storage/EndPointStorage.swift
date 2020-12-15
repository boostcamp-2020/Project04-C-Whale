//
//  EndPointStorage.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/14.
//

import CoreData

protocol EndPointStorageType {
    func fetchEndPoints(completion: @escaping (([EndPointMO], Error?) -> Void))
    func deleteEndPoint(_ endPoint: EndPointMO)
}

extension Storage: EndPointStorageType {
    func fetchEndPoints(completion: @escaping (([EndPointMO], Error?) -> Void)) {
        childContext.perform {
            let fetchRequest = NSFetchRequest<EndPointMO>(entityName: "EndPointMO")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
            do {
                let endPointList = try self.childContext.fetch(fetchRequest)
                completion(endPointList, nil)
            } catch let error {
                completion([], StorageError.read(error.localizedDescription))
            }
        }
    }
    
    func deleteEndPoint(_ endPoint: EndPointMO) {
        childContext.perform {
            self.childContext.delete(endPoint)
            self.saveContext(context: self.childContext)
        }
    }
}
