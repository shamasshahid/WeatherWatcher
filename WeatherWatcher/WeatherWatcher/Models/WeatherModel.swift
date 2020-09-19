//
//  WeatherModel.swift
//  WeatherWatcher
//
//  Created by Shamas on 18/9/20.
//

import Foundation

struct WeatherModel: Codable {
    let coord: Coord
    let sys: Sys
    let weather: [Weather]
    let main: Main
    let visibility: Int?
    let wind: Wind
    let clouds: Clouds
    let dt, id: Int
    let name: String
}
