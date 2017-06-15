//
//  HorizontalDomains+CoreDataProperties.swift
//  investHR
//
//  Created by mac on 15/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation
import CoreData


extension HorizontalDomains {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HorizontalDomains> {
        return NSFetchRequest<HorizontalDomains>(entityName: "HorizontalDomains");
    }

    @NSManaged public var horizontalName: String?
    @NSManaged public var horizontalId: Int16

}
