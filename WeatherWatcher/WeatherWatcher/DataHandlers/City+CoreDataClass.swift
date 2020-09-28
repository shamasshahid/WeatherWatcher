//
//  City+CoreDataClass.swift
//  WeatherWatcher
//
//  Created by Shamas on 20/9/20.
//
//

import Foundation
import CoreData

@objc(City)
public class City: NSManagedObject {
    
    func populateFromModel(model: CityModel) {
        id = Int32(model.id)
        name = model.name
        country = model.country
        state = model.state
        longitude = model.coord.lon
        latitude = model.coord.lat
    }
    
    func getCityStorageModel() -> CityStorageModel {
        let model: CityStorageModel = CityStorageModel(id: Int(id), name: name ?? "", state: state ?? "", country: country ?? "", coord: Coord(lon: longitude, lat: latitude), isSelected: isSelected)
        return model
    }
}
