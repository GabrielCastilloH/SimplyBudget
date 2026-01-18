//
//  Expenditure+CoreDataProperties.swift
//  
//
//  Created by Gabriel Castillo on 10/11/23.
//
//

import Foundation
import CoreData


extension Expenditure {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expenditure> {
        return NSFetchRequest<Expenditure>(entityName: "Expenditure")
    }

    @NSManaged public var amount: Int64
    @NSManaged public var category: String?
    @NSManaged public var timeStamp: Date?
    @NSManaged public var expenditureToUser: User?

}
