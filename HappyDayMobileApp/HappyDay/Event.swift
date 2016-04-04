//
//  Event.swift
//  HappyDay
//
//  Created by David Prochazka on 09/03/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Event: NSManagedObject {

    // factory method that creates an event with required information
    static func createEventForPerson(person: Person, withHappiness happiness: Float, inTime timestamp: NSDate) -> Event {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: managedObjectContext)
        let newEvent = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext) as! Event
        // alternative
        //let newEvent = NSEntityDescription.insertNewObjectForEntityForName(entity!.name!, inManagedObjectContext: managedObjectContext) as! Event
            
        newEvent.timeStamp = timestamp
        newEvent.happiness = happiness
        newEvent.person = person
        
        do {
            try managedObjectContext.save()
        } catch {
            abort()
        }
        
        return newEvent
    }
}
