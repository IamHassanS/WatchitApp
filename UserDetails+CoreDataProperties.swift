//
//  UserDetails+CoreDataProperties.swift
//  
//
//  Created by trioangle on 18/10/23.
//
//

import Foundation
import CoreData


extension UserDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetails> {
        return NSFetchRequest<UserDetails>(entityName: "UserDetails")
    }

    @NSManaged public var username: String?
    @NSManaged public var userimageURL: String?

}
