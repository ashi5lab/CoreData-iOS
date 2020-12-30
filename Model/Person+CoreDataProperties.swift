//
//  Person+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by Ashique on 31/12/20.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int64
    @NSManaged public var gender: String?
    @NSManaged public var family: Family?

}

extension Person : Identifiable {

}
