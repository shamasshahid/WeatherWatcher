//
//  CityWeatherTVCViewModel.swift
//  WeatherWatcher
//
//  Created by Shamas on 20/9/20.
//

import Foundation

class CityWeatherTVCViewModel {
    
    let weatherModel: WeatherModel
    
    init(model: WeatherModel) {
        weatherModel = model
    }
    
    var cityName: String {
        return weatherModel.name
    }
    
    var temperature: String {
        return "\(weatherModel.main.temp) °C"
    }
    
}
