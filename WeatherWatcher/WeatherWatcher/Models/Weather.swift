//
//  Weather.swift
//  WeatherWatcher
//
//  Created by Shamas on 18/9/20.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
