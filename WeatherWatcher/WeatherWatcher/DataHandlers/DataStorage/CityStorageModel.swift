//
//  CityStorageModel.swift
//  WeatherWatcher
//
//  Created by Shamas on 22/9/20.
//

import Foundation

class CityStorageModel: CityModel {
    var isSelected: Bool = false
    
    init(id: Int, name: String, state: String, country: String, coord: Coord, isSelected: Bool) {
        super.init(id: id, name: name, state: state, country: country, coord: coord)
        self.isSelected = isSelected
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
