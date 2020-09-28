//
//  AppConfig.swift
//  WeatherWatcher
//
//  Created by Shamas on 19/9/20.
//

import Foundation

class AppConfig {
    
    static let appKey = "weatherApiKey"
    
    static var WEATHER_API_KEY: String {
        guard let fetchKey = Bundle.main.object(forInfoDictionaryKey: appKey) as? String, !fetchKey.isEmpty else {
            fatalError("Weather API Key Missing. Please put a valid key in WeatherWatcherConfig.xcconfig")
        }
        return fetchKey
    }
    
}
