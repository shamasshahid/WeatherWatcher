//
//  WeatherResponseModel.swift
//  WeatherWatcher
//
//  Created by Shamas on 18/9/20.
//

import Foundation

struct WeatherResponse: Codable {
    let cnt: Int
    let list: [WeatherModel]
}
