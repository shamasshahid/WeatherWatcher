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
    let storage: Storage
    var currentSearchString = ""
    
    var dataFetchOffset = 0 {
        didSet {
            requestCities()
        }
    }
    
    var allCities: [CityStorageModel] = [] {
        didSet {
            dataUpdated?()
        }
    }
    
    init(storage: Storage) {
        self.storage = storage
        requestCities()
    }
    
    var citiesCount: Int {
        return allCities.count
    }
    
    private func requestCities() {
        allCities.append(contentsOf: storage.getAllCitiesMatching(matchingString: currentSearchString, with: dataFetchOffset))
    }
    
    func userUpdatedString(searchString: String) {
        currentSearchString = searchString
        allCities.removeAll()
        requestCities()
    }
    
    private func cityObjectForIndex(index: Int) -> CityStorageModel? {
        guard index >= 0 && index < allCities.count else {
            return nil
        }
        return allCities[index]
    }
    
    func selectionChangedFor(isSelected: Bool, index: Int) {
        if let city = cityObjectForIndex(index: index) {
            city.isSelected = isSelected
            storage.updateCityModelSelection(model: city)
        }
    }
    
    func updateSearchOffsetForIndex(index: Int) {
        let newOffSet = (index + 1) / storage.fetchBatchSize
        if newOffSet > dataFetchOffset {
            dataFetchOffset = newOffSet
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
