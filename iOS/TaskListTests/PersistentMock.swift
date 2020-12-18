////
////  PersistentceMock.swift
////  TaskListTests
////
////  Created by woong on 2020/12/17.
////

import Foundation
import CoreData

final class PersistentContainerMock: NSPersistentContainer {
    
    // MARK: - Constants
    
    private static let persistentContainerName = "HalgoraeDO"
    var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    // MARK: - Core Data stack
    
    static let shared: PersistentContainerMock = {
        let container = PersistentContainerMock(name: persistentContainerName)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
        
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
