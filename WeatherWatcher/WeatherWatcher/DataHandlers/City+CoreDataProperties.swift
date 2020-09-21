//
//  City+CoreDataProperties.swift
//  WeatherWatcher
//
//  Created by Shamas on 20/9/20.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var state: String?
    @NSManaged public var country: String?
    @NSManaged public var longitude: Float
    @NSManaged public var latitude: Float
    @NSManaged public var isSelected: Bool
}

extension City : Identifiable {

}
