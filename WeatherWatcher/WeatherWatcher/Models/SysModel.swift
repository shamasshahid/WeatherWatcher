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
}
