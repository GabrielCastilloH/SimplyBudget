//
//  User+CoreDataProperties.swift
//  
//
//  Created by Gabriel Castillo on 10/11/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var dailyBudget: Int64
    @NSManaged public var totalSpending: NSSet?

}

// MARK: Generated accessors for totalSpending
extension User {

    @objc(addTotalSpendingObject:)
    @NSManaged public func addToTotalSpending(_ value: Expenditure)

    @objc(removeTotalSpendingObject:)
    @NSManaged public func removeFromTotalSpending(_ value: Expenditure)

    @objc(addTotalSpending:)
    @NSManaged public func addToTotalSpending(_ values: NSSet)

    @objc(removeTotalSpending:)
    @NSManaged public func removeFromTotalSpending(_ values: NSSet)

}
