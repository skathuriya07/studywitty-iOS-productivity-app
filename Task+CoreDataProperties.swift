//
//  Task+CoreDataProperties.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 04/05/21.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var date: Date?
    @NSManaged public var completed: Bool
    @NSManaged public var task: String?
    @NSManaged public var taskForSession: Session?
    @NSManaged public var sessionName: String?
    @NSManaged public var taskId: String?

}

extension Task : Identifiable {

}
