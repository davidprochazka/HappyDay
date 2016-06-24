//
//  Team+CoreDataProperties.swift
//  HappyDaysCollectionVersion
//
//  Created by David Prochazka on 19/05/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Team {

    @NSManaged var image: NSData?
    @NSManaged var name: String?
    @NSManaged var members: NSSet?

}
