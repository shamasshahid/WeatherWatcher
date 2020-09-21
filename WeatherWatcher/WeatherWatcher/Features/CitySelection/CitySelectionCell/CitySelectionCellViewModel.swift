//
//  CitySelectionCellViewModel.swift
//  WeatherWatcher
//
//  Created by Shamas on 20/9/20.
//

import Foundation

class CitySelectionCellViewModel {
    
    let cityObject: City
    
    init(object: City) {
        cityObject = object
    }
    
    var cityName: String {
        return String(format: "%@ - %@", cityObject.name ?? "", cityObject.country ?? "")
    }
    
    var isSelected: Bool {
        return cityObject.isSelected
    }
}