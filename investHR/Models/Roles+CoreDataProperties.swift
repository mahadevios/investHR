//
//  Roles+CoreDataProperties.swift
//  investHR
//
//  Created by mac on 15/06/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation
import CoreData


extension Roles {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Roles> {
        return NSFetchRequest<Roles>(entityName: "Roles");
    }

    @NSManaged public var roleId: Int16
    @NSManaged public var roleName: String?

}
