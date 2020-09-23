//
//  DependencyProvider.swift
//  WeatherWatcher
//
//  Created by Shamas on 19/9/20.
//

import Foundation

/// Protocol which defines the required service and routable
protocol Dependencies {
    static func getService() -> WebService
    
    static func getStorage() -> Storage
}

/// Implementation for ConverterDependencies which returns WebService, and Routable
class DependencyProvider: Dependencies {
    
    static func getService() -> WebService {
        return WeatherService()
    }
    
    static func getStorage() -> Storage {
        return DataStorage()
    }
}
