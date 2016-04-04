//
//  Person.swift
//  HappyDay
//
//  Created by David Prochazka on 09/03/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Person: NSManagedObject {

    // factory method that creates a person with required information in appropriate team
    static func createPersonWithName(name: String, andImage image: UIImage, inTeam team: Team) -> Person {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedObjectContext)
        let newPerson = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext) as! Person
        
        newPerson.name = name
        newPerson.image = UIImagePNGRepresentation(image)
        newPerson.team = team
        
        do {
            try managedObjectContext.save()
        } catch {
            abort()
        }
        
        return newPerson
    }
}
