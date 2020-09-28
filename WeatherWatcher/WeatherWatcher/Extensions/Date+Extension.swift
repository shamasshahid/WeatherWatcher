//
//  Date+Extension.swift
//  WeatherWatcher
//
//  Created by Shamas on 22/9/20.
//

import Foundation

extension Date {
    
    static let mediumDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    func getFormattedDateToMediumStyle() -> String {
        return Date.mediumDateFormatter.string(from: self)
    }
}
