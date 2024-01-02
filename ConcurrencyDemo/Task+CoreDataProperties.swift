//
//  Task+CoreDataProperties.swift
//  ConcurrencyDemo
//
//  Created by Sameer Personal on 1/2/24.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var details: String?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var ofUser: User?

}

extension Task : Identifiable {

}
