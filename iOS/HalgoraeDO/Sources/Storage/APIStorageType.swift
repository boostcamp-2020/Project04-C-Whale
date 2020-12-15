//
//  APIStorageType.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/14.
//

import CoreData

protocol APIStorageType {
    func saveEndPoint(_ endPoint: EndPointType)
    func fetchEndPoint(completion: @escaping (([EndPointMO], Error?) -> Void))
    func deleteEndPoint(_ endPoint: EndPointMO)
}

extension APIStorageType {
    func fetchEndPoint(completion: @escaping (([EndPointMO], Error?) -> Void)) {
        let context = Storage().childContext
        context.perform {
            let fetchRequest = NSFetchRequest<EndPointMO>(entityName: "EndPointMO")
            do {
                let endPoints = try context.fetch(fetchRequest)
                completion(endPoints, nil)
            } catch  {
                completion([], error)
            }
        }
    }

    func saveEndPoint(_ endPoint: EndPointType) {
        let context = Storage().childContext
        let _ = EndPointMO(context: context, endPoint: endPoint)
        Storage().saveContext(context: context)
    }
    
    func deleteEndPoint(_ endPoint: EndPointMO) {
        let context = Storage().childContext
        context.delete(endPoint)
        Storage().saveContext(context: context)
    }
}
