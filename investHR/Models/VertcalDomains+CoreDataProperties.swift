//
//  VertcalDomains+CoreDataProperties.swift
//  investHR
//
//  Created by mac on 13/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation
import CoreData


extension VertcalDomains {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VertcalDomains> {
        return NSFetchRequest<VertcalDomains>(entityName: "VertcalDomains");
    }

    @NSManaged public var domainName: String?

}
