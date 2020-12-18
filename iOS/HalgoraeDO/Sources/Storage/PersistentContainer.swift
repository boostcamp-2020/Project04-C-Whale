//
//  PersistentContainer.swift
//  HalgoraeDO
//
//  Created by woong on 2020/12/12.
//

import CoreData

final class PersistentContainer: NSPersistentContainer, PersistentProviding {
    
    // MARK: - Constants
    
    private static let persistentContainerName = "HalgoraeDO"
    var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    // MARK: - Core Data stack
    
    static let shared: PersistentContainer = {
        let container = PersistentContainer(name: persistentContainerName)
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        
        container.mainContext = container.viewContext
        container.childContext.parent = container.mainContext
        
        return container
    }()
}
