//
//  Person.swift
//  HappyDaysCollectionVersion
//
//  Created by David Prochazka on 19/05/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Person: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    // factory method that creates a team with required information
    static func createPersonWithName(name: String, andImage image: UIImage, andTeam team: Team) -> Person {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedObjectContext)
        let newPerson = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext) as! Person
        
        newPerson.name = name
        newPerson.image = UIImagePNGRepresentation(image)
        newPerson.team = team;
        
        do {
            try managedObjectContext.save()
        } catch {
            abort()
        }
        
        return newPerson
    }
    
}
