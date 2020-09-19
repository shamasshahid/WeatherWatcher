//
//  DependencyProvider.swift
//  WeatherWatcher
//
//  Created by Shamas on 19/9/20.
//

import Foundation

/// Protocol which defines the required service and routable
protocol Dependencies {
    func getService() -> WebService
    func getRoutable() -> Routable
}

/// Implementation for ConverterDependencies which returns WebService, and Routable
class DependencyProvider: Dependencies {
    
    func getService() -> WebService {
        return WeatherService()
    }

    func getRoutable() -> Routable {
        return BaseRouter()
    }
}
