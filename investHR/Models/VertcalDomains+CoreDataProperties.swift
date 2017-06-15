//
//  VertcalDomains+CoreDataProperties.swift
//  investHR
//
//  Created by mac on 15/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation
import CoreData


extension VertcalDomains {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VertcalDomains> {
        return NSFetchRequest<VertcalDomains>(entityName: "VertcalDomains");
    }

    @NSManaged public var verticalName: String?
    @NSManaged public var verticalId: Int16

}
