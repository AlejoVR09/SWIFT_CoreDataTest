//
//  Country+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Alejandro Vanegas Rondon on 6/02/24.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var name: String?

}

extension Country : Identifiable {

}
