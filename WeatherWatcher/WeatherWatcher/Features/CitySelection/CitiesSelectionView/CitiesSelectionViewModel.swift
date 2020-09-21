//
//  CitiesSelectionViewModel.swift
//  WeatherWatcher
//
//  Created by Shamas on 20/9/20.
//

import Foundation
import CoreData

class CitiesSelectionViewModel {
    
    var dataUpdated: (() -> Void)?
    
    var allCities: [City] = [] {
        didSet {
            dataUpdated?()
        }
    }
    
    init() {
        loadAllCities(searchString: "")
    }
    
    var citiesCount: Int {
        return allCities.count
    }
    
    private func loadAllCities(searchString: String) {
        allCities = DataStorage.shared.getAllCitiesMatching(matchingString: searchString)
    }
    
    func userUpdatedString(searchString: String) {
        loadAllCities(searchString: searchString)
    }
    
    private func cityObjectForIndex(index: Int) -> City? {
        guard index >= 0 && index < allCities.count else {
            return nil
        }
        return allCities[index]
    }
    
    func selectionChangedFor(isSelected: Bool, index: Int) {
        if let city = cityObjectForIndex(index: index) {
            city.isSelected = isSelected
            try? city.managedObjectContext?.save()
        }
        
    }
    
    func cityViewModelForIndex(index: Int) -> CitySelectionCellViewModel? {
        
        guard let city = cityObjectForIndex(index: index) else {
            return nil
        }
        
        return CitySelectionCellViewModel(object: city)
    }
}
