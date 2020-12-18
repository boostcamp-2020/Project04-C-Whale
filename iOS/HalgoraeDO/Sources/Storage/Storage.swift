//
//  Storage.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/12.
//

import Foundation
import CoreData

protocol PersistentProviding {
    var mainContext: NSManagedObjectContext { get }
    var childContext: NSManagedObjectContext { get }
}

class Storage {
    
    let mainContext: NSManagedObjectContext
    let childContext: NSManagedObjectContext
    
    enum StorageError: Error {
        case create(String)
        case read(String)
        case update(String)
        case delete(String)
    }
    
    init(container: PersistentProviding = PersistentContainer.shared) {
        self.mainContext = container.mainContext
        self.childContext = container.childContext
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
