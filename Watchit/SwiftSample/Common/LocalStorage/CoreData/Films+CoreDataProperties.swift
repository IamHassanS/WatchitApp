//
//  Films+CoreDataProperties.swift
//  
//
//  Created by HASSAN on 21/10/23.
//
//

import Foundation
import CoreData


extension Films {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Films> {
        return NSFetchRequest<Films>(entityName: "Films")
    }

    @NSManaged public var name: String?
    @NSManaged public var film: NSSet?

}

// MARK: Generated accessors for film
extension Films {

    @objc(addFilmObject:)
    @NSManaged public func addToFilm(_ value: Film)

    @objc(removeFilmObject:)
    @NSManaged public func removeFromFilm(_ value: Film)

    @objc(addFilm:)
    @NSManaged public func addToFilm(_ values: NSSet)

    @objc(removeFilm:)
    @NSManaged public func removeFromFilm(_ values: NSSet)

}
