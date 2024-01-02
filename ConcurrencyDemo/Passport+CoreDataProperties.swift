//
//  Passport+CoreDataProperties.swift
//  ConcurrencyDemo
//
//  Created by Sameer Personal on 1/2/24.
//
//

import Foundation
import CoreData


extension Passport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Passport> {
        return NSFetchRequest<Passport>(entityName: "Passport")
    }

    @NSManaged public var expiryDate: Date?
    @NSManaged public var number: String?
    @NSManaged public var ofUser: User?

}

extension Passport : Identifiable {

}
