//
//  WeatherDetailViewModel.swift
//  WeatherWatcher
//
//  Created by Shamas on 21/9/20.
//

import Foundation

typealias WeatherDetailLabelValue = (label: String, value: String)

enum DetailLabel: String {
    case temperature = "Temperature"
    case minTemperature = "Minimum Temperature"
    case maxTemperature = "Maximum Temperature"
    case sunRise = "Sun Rise"
    case sunSet = "Sun Set"
}

class WeatherDetailViewModel {
    
    let weatherModel: WeatherModel
    var weatherDetailPairs: [WeatherDetailLabelValue] = []
    
    var numberOfRows: Int {
        return weatherDetailPairs.count
    }
    
    init(weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
        populatePairs()
    }
    
    private func populatePairs() {
        // temperature cells
        weatherDetailPairs.append(WeatherDetailLabelValue(label: DetailLabel.temperature.rawValue, value: weatherModel.main.temp.getFormattedStringWithMetric()))
        weatherDetailPairs.append(WeatherDetailLabelValue(label: DetailLabel.minTemperature.rawValue, value: weatherModel.main.tempMin.getFormattedStringWithMetric()))
        weatherDetailPairs.append(WeatherDetailLabelValue(label: DetailLabel.maxTemperature.rawValue, value: weatherModel.main.tempMax.getFormattedStringWithMetric()))
        // sun timing cells
        weatherDetailPairs.append(WeatherDetailLabelValue(label: DetailLabel.sunRise.rawValue, value: weatherModel.sys.sunriseDate?.getFormattedDateToMediumStyle() ?? ""))
        weatherDetailPairs.append(WeatherDetailLabelValue(label: DetailLabel.sunSet.rawValue, value: weatherModel.sys.sunsetDate?.getFormattedDateToMediumStyle() ?? ""))
    }
    
    private func detailPairModelForIndex(index: Int) -> WeatherDetailLabelValue? {
        guard index >= 0 && index < weatherDetailPairs.count else {
            return nil
        }
        return weatherDetailPairs[index]
    }
    
    func getViewModelForIndex(index: Int) -> WeatherDetailCellViewModel? {
        guard let model = detailPairModelForIndex(index: index) else {
            return nil
        }
        
        return WeatherDetailCellViewModel(valuePair: model)
    }
    
}
