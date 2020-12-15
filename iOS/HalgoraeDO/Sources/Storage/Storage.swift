//
//  Storage.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/12.
//

import Foundation
import CoreData

class Storage {
    let mainContext = PersistentContainer.shared.mainContext
    let childContext = PersistentContainer.shared.childContext
    
    enum StorageError: Error {
        case create(String)
        case read(String)
        case update(String)
        case delete(String)
    }
    
    // MARK: - Core Data Saving support

    func saveContext (context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
