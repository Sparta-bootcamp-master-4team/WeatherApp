//
//  Entity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by tlswo on 5/22/25.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var name: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?

}

extension Entity : Identifiable {

}
