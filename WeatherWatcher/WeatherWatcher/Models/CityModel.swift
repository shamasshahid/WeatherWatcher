//
//  CityModel.swift
//  WeatherWatcher
//
//  Created by Shamas on 20/9/20.
//

import Foundation

typealias CityModelList = [CityModel]

class CityModel: Codable {
    var id: Int
    var name: String
    var state: String
    var country: String
    var coord: Coord
    
    init(id: Int, name: String, state: String, country: String, coord: Coord) {
        self.id = id
        self.name = name
        self.state = state
        self.country = country
        self.coord = coord
    }
}
