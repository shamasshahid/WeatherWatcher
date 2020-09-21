//
//  DataStorage.swift
//  WeatherWatcher
//
//  Created by Shamas on 20/9/20.
//

import Foundation
import CoreData

class DataStorage {
    
    static let hasLoadedData = "hasLoadedData"
    
    static let shared = DataStorage()
    
    var onPreloadStarted: (() -> Void)?
    var onPreloadFinished: (() -> Void)?
    
    init() {
    }
    
    func prepareForUse() {
        preloadData()
    }
    
    var hasPreLoadedData: Bool {
        get {
            return UserDefaults.standard.bool(forKey: DataStorage.hasLoadedData)
        }
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: DataStorage.hasLoadedData)
        }
    }
    
    
    
    lazy var persistentContainer: NSPersistentContainer = {
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

    private func preloadData() {
        
        onPreloadStarted?()
        if !hasPreLoadedData {
            let cityList = getCityListFromJSONFile()
            
            let bgContext = persistentContainer.newBackgroundContext()
            bgContext.perform {
                for aCityModel in cityList {
                    let cityCoreDataObject = City(context: bgContext)
                    cityCoreDataObject.id = Int32(aCityModel.id)
                    cityCoreDataObject.name = aCityModel.name
                    cityCoreDataObject.country = aCityModel.country
                    cityCoreDataObject.state = aCityModel.state
                    if aCityModel.id == 2158177 || aCityModel.id == 2147714 || aCityModel.id == 2174003 {
                        cityCoreDataObject.isSelected = true
                    }
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
    
    func getAllCitiesMatching(matchingString: String) -> [City] {
        var fetchedCities: [City] = []
        let cityFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        cityFetch.sortDescriptors = [NSSortDescriptor(keyPath: \City.name, ascending: true)]
        
        if !matchingString.isEmpty {
            cityFetch.predicate = NSPredicate(format: "name CONTAINS[c] %@", matchingString)
        }
        
        do {
            fetchedCities = try persistentContainer.viewContext.fetch(cityFetch) as! [City]
        } catch {
            print("Failed to fetch cities: \(error)")
            
        }
        return fetchedCities
    }
    
    func getIDsForSelectedCities() -> [Int32] {
        var fetchedCities: [City] = []
        let cityFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
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
            print("count is \(cityList.count)")
        } catch {
            print(error)
        }
        
        return cityList
    }
}
