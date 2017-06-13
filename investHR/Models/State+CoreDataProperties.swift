//
//  State+CoreDataProperties.swift
//  investHR
//
//  Created by mac on 13/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation
import CoreData


extension State {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<State> {
        return NSFetchRequest<State>(entityName: "State");
    }

    @NSManaged public var id: Int16
    @NSManaged public var stateName: String?

}
