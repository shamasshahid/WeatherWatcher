//
//  CityModel.swift
//  WeatherWatcher
//
//  Created by Shamas on 20/9/20.
//

import Foundation

typealias CityModelList = [CityModel]

struct CityModel: Codable {
    var id: Int
    var name: String
    var state: String
    var country: String
}
