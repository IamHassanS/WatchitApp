//
//  Film+CoreDataProperties.swift
//  
//
//  Created by HASSAN on 21/10/23.
//
//

import Foundation
import CoreData


extension Film {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Film> {
        return NSFetchRequest<Film>(entityName: "Film")
    }

    @NSManaged public var movieDescription: String?
    @NSManaged public var movieGenre: String?
    @NSManaged public var movieID: Int32
    @NSManaged public var movieImageurl: Data?
    @NSManaged public var movieName: String?
    @NSManaged public var movieReleaseDate: String?
    @NSManaged public var movieUpvotePopularity: String?
    @NSManaged public var films: Films?

}
