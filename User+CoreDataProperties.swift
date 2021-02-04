//
//  User+CoreDataProperties.swift
//  FakeNewsIdentifier
//
//  Created by 陳姸汝 on 2021/1/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var input_news: String
    @NSManaged public var actual: Bool
    @NSManaged public var predicted: Bool

}

extension User : Identifiable {

}
