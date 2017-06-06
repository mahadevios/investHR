//
//  VerticalDomains+CoreDataProperties.swift
//  
//
//  Created by mac on 06/06/17.
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
