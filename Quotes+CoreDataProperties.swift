//
//  Quotes+CoreDataProperties.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 04/05/21.
//
//

import Foundation
import CoreData


extension Quotes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quotes> {
        return NSFetchRequest<Quotes>(entityName: "Quotes")
    }

    @NSManaged public var quote: String?
    @NSManaged public var author: String?
    @NSManaged public var date: Date?
    @NSManaged public var quoteId: String?

}

extension Quotes : Identifiable {

}
