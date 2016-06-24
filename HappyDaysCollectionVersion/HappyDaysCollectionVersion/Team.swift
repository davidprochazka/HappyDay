//
//  Team.swift
//  HappyDaysCollectionVersion
//
//  Created by David Prochazka on 19/05/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Team: NSManagedObject {

    // factory method that creates a team with required information
    static func createTeamWithName(name: String, andImage image: UIImage) -> Team {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Team", inManagedObjectContext: managedObjectContext)
        let newTeam = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext) as! Team
        
        newTeam.name = name
        newTeam.image = UIImagePNGRepresentation(image)
        
        do {
            try managedObjectContext.save()
        } catch {
            abort()
        }
        
        return newTeam
    }
}
