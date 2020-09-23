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
    
    // todo: remove default comments
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CitiesList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
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
