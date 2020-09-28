//
//  SysModel.swift
//  WeatherWatcher
//
//  Created by Shamas on 18/9/20.
//

import Foundation

struct Sys: Codable {
    let country: String
    let timezone, sunrise, sunset: Int
    
    var sunriseDate: Date? {
        return Date(timeIntervalSince1970: TimeInterval(sunrise))
    }
    
    var sunsetDate: Date? {
        return Date(timeIntervalSince1970: TimeInterval(sunset))
    }
}
