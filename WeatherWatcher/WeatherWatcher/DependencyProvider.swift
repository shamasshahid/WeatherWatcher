//
//  DependencyProvider.swift
//  WeatherWatcher
//
//  Created by Shamas on 19/9/20.
//

import Foundation
import CoreData

/// Protocol which defines the required service and routable
protocol Dependencies {
    static func getService() -> WebService
    
    static func getStorage() -> Storage
    
    static func getPersistentContainer() -> NSPersistentContainer
}

/// Implementation for ConverterDependencies which returns WebService, and Routable
class DependencyProvider: Dependencies {
    
    static func getService() -> WebService {
        return WeatherService()
    }
    
    static func getStorage() -> Storage {
        return DataStorage(container: DependencyProvider.getPersistentContainer())
    }
    
    static func getPersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "CitiesList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
//                TODO: remove once handled
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }
}
