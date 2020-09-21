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
    
    var searchOffset = 0 {
        didSet {
            requestCities()
        }
    }
    
    var currentSearchString = ""
    
    var allCities: [City] = [] {
        didSet {
            dataUpdated?()
        }
    }
    
    init() {
        requestCities()
    }
    
    var citiesCount: Int {
        return allCities.count
    }
    
    private func requestCities() {
        allCities.append(contentsOf: DataStorage.shared.getAllCitiesMatching(matchingString: currentSearchString, with: searchOffset))
    }
    
    func userUpdatedString(searchString: String) {
        currentSearchString = searchString
        requestCities()
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
    
    func updateSearchOffsetForIndex(index: Int) {
        let newOffSet = (index + 1) / DataStorage.fetchBatchSize
        if newOffSet > searchOffset {
            searchOffset = newOffSet
        }
    }
    
    func cityViewModelForIndex(index: Int) -> CitySelectionCellViewModel? {
        
        guard let city = cityObjectForIndex(index: index) else {
            return nil
        }
        
        updateSearchOffsetForIndex(index: index)
        
        return CitySelectionCellViewModel(object: city)
    }
}
