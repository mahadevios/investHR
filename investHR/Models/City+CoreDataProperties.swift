//
//  City+CoreDataProperties.swift
//  investHR
//
//  Created by mac on 01/08/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City");
    }

    @NSManaged public var cityName: String?
    @NSManaged public var id: Int64
    @NSManaged public var stateId: Int16

}
