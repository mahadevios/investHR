//
//  AppliedJobs+CoreDataProperties.swift
//  investHR
//
//  Created by mac on 01/08/17.
//  Copyright © 2017 Xanadutec. All rights reserved.
//

import Foundation
import CoreData


extension AppliedJobs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppliedJobs> {
        return NSFetchRequest<AppliedJobs>(entityName: "AppliedJobs");
    }

    @NSManaged public var domainType: String?
    @NSManaged public var jobId: String?
    @NSManaged public var userId: String?

}
