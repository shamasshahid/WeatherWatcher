//
//  WeatherDetailViewModel.swift
//  WeatherWatcher
//
//  Created by Shamas on 23/9/20.
//

import Foundation

class WeatherDetailCellViewModel {
    let valuePair: WeatherDetailLabelValue
    
    init(valuePair: WeatherDetailLabelValue) {
        self.valuePair = valuePair
    }
    
    var titleValue: String {
        return valuePair.label
    }
    
    var detailValue: String {
        return valuePair.value
    }
}
