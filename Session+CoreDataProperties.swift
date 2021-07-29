//
//  Session+CoreDataProperties.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by Shreya Kathuriya on 04/05/21.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var sessionType: String?
    @NSManaged public var sessionId: Int16
    @NSManaged public var sessionCompleted: Bool
    @NSManaged public var numberOfTasks: Int16
    @NSManaged public var numberOfTasksCompleted: Int16
    @NSManaged public var tasksInThisSession: NSSet?

}

// MARK: Generated accessors for tasksInThisSession
extension Session {

    @objc(addTasksInThisSessionObject:)
    @NSManaged public func addToTasksInThisSession(_ value: Task)

    @objc(removeTasksInThisSessionObject:)
    @NSManaged public func removeFromTasksInThisSession(_ value: Task)

    @objc(addTasksInThisSession:)
    @NSManaged public func addToTasksInThisSession(_ values: NSSet)

    @objc(removeTasksInThisSession:)
    @NSManaged public func removeFromTasksInThisSession(_ values: NSSet)

}

extension Session : Identifiable {

}
