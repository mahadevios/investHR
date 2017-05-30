//
//  VerticalDomains+CoreDataProperties.swift
//  
//
//  Created by mac on 30/05/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension VerticalDomains {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VerticalDomains> {
        return NSFetchRequest<VerticalDomains>(entityName: "VerticalDomains");
    }

    @NSManaged public var domainName: String?

}
