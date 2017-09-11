//
//  ZSpecialNotification+CoreDataProperties.swift
//  investHR
//
//  Created by mac on 11/09/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation
import CoreData


extension ZSpecialNotification {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ZSpecialNotification> {
        return NSFetchRequest<ZSpecialNotification>(entityName: "ZSpecialNotification")
    }

    @NSManaged public var notificationId1: Int16
    @NSManaged public var notificationDate: String?
    @NSManaged public var notificationType: Int16
    @NSManaged public var subject: String?
    @NSManaged public var userId: String?

}
