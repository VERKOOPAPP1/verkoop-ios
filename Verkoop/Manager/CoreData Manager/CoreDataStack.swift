//
//  CoreDataStack.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 08/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: NSObject {
    
    static let moduleName = "ChatModel"
    static let shared = CoreDataStack()
    
    private override init() {
        super.init()
        _ = self.persistentContainer
    }
    
    func saveContextPrivate() {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        context.parent = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.moduleName)
        container.persistentStoreDescriptions.first?.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions.first?.shouldMigrateStoreAutomatically = true
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
//            print("Coordinator URL - \(storeDescription)")
        })
        return container
    }()
}
