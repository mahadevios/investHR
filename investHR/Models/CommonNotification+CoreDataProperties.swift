//
//  CommonNotification+CoreDataProperties.swift
//  investHR
//
//  Created by mac on 18/09/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation
import CoreData


extension CommonNotification {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommonNotification> {
        return NSFetchRequest<CommonNotification>(entityName: "CommonNotification")
    }

    @NSManaged public var jobId: Int64
    @NSManaged public var notificationDate1: String?
    @NSManaged public var notificationId: Int16
    @NSManaged public var notificationType: Int16
    @NSManaged public var subject: String?
    @NSManaged public var userId: String?
    @NSManaged public var readStatus: Int16

}
