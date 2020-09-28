//
//  MockDependencyProvider.swift
//  WeatherWatcherTests
//
//  Created by Shamas on 23/9/20.
//

import Foundation
import CoreData
@testable import WeatherWatcher

class MockDependencyProvider: Dependencies {
    
    static func getPersistentContainer() -> NSPersistentContainer {
        
        let container = NSPersistentContainer(name: "CitiesListTest")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = true
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition( description.type == NSInMemoryStoreType )
                                        
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem container failed \(error)")
            }
        }
        return container

    }
    
    
    static func getService() -> WebService {
        return MockWeatherService()
    }
    
    static func getStorage() -> Storage {
        return DataStorage(container: MockDependencyProvider.getPersistentContainer())
    }
}
