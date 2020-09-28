//
//  DataStorage.swift
//  WeatherWatcher
//
//  Created by Shamas on 20/9/20.
//

import Foundation
import CoreData

protocol Storage {
    
    var fetchBatchSize: Int {get set}
    var onPreloadStarted: (() -> Void)? { get set }
    var onPreloadFinished: (() -> Void)? { get set }
    var preSetCityIDs: [Int32] { get set }
    func start()
    func getAllCitiesMatching(matchingString: String, with offset: Int) -> [CityStorageModel]
    func getIDsForSelectedCities() -> [Int32]
    func updateCityModelSelection(model: CityStorageModel)
}

class DataStorage: Storage {
    
    var preSetCityIDs: [Int32] = [2158177, 2147714, 2174003]
    
    private static let hasLoadedData = "hasLoadedData"
    
    var fetchBatchSize = 50
    
    var onPreloadStarted: (() -> Void)?
    var onPreloadFinished: (() -> Void)?
    
    private var hasPreLoadedData: Bool {
        get {
            return UserDefaults.standard.bool(forKey: DataStorage.hasLoadedData)
        }
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: DataStorage.hasLoadedData)
        }
    }
    
    // todo
    let persistentContainer: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        persistentContainer = container
    }
    
    func start() {
        preloadData()
    }

    private func preloadData() {
        
        onPreloadStarted?()
        if !hasPreLoadedData {
            let cityList = getCityListFromJSONFile()
            
            let bgContext = persistentContainer.newBackgroundContext()
            bgContext.perform {
                for aCityModel in cityList {
                    let cityCoreDataObject = City(context: bgContext)
                    cityCoreDataObject.populateFromModel(model: aCityModel)
                    cityCoreDataObject.isSelected = self.preSetCityIDs.contains(cityCoreDataObject.id)
                }
                
                do {
                    try bgContext.save()
                    self.hasPreLoadedData = true
                    self.onPreloadFinished?()
                } catch {
                    print(error)
                    self.onPreloadFinished?()
                }
            }
        } else {
            onPreloadFinished?()
        }
    }
    
    func getAllCitiesMatching(matchingString: String, with offset: Int) -> [CityStorageModel] {
        var fetchedCities: [City] = []
        let cityFetch = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: City.self))
        cityFetch.sortDescriptors = [NSSortDescriptor(keyPath: \City.name, ascending: true)]
        
        if !matchingString.isEmpty {
            cityFetch.predicate = NSPredicate(format: "name CONTAINS[c] %@", matchingString)
        }
        
        cityFetch.fetchOffset = offset * fetchBatchSize
        cityFetch.fetchLimit = fetchBatchSize
        
        do {
            fetchedCities = try persistentContainer.viewContext.fetch(cityFetch) as! [City]
        } catch {
            print("Failed to fetch cities: \(error)")
            
        }
        
        print("matching cities are \(fetchedCities.count)")
        
        return fetchedCities.map({ $0.getCityStorageModel() })
    }
    
    func updateCityModelSelection(model: CityStorageModel) {
        
        let cityFetch = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: City.self))
        cityFetch.predicate = NSPredicate(format: "id == %d", model.id)
        do {
            let fetchedCity = try persistentContainer.viewContext.fetch(cityFetch) as! [City]
            if let first = fetchedCity.first {
                first.isSelected = model.isSelected
                try? first.managedObjectContext?.save()
            }
        } catch {
            print("Failed to fetch/update city: \(error)")
        }
    }
    
    func getIDsForSelectedCities() -> [Int32] {
        var fetchedCities: [City] = []
        let cityFetch = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: City.self))
        cityFetch.sortDescriptors = [NSSortDescriptor(keyPath: \City.name, ascending: true)]
        
        cityFetch.predicate = NSPredicate(format: "isSelected == true")
        do {
            fetchedCities = try persistentContainer.viewContext.fetch(cityFetch) as! [City]
        } catch {
            print("Failed to fetch cities: \(error)")
            
        }
        
        let ids = fetchedCities.map({ $0.id })
        
        return ids

    }
    
    private func getCityListFromJSONFile() -> CityModelList {
        var cityList: CityModelList = []
        let path = Bundle.main.path(forResource: "cityList", ofType: "json")
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path!))
            cityList = try JSONDecoder().decode(CityModelList.self, from: data)
        } catch {
            print(error)
        }
        
        return cityList
    }
}
