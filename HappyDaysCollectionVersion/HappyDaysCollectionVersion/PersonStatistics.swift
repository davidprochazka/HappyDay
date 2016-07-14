//
//  TeamStatistics.swift
//  HappyDaysCollectionVersion
//
//  Created by Ivo Pisarovic on 14/07/16.
//  Copyright © 2016 David Prochazka. All rights reserved.
//

import Foundation
import CoreData

class PersonStatistics: Statistics {
    
    var person: Person?
    
    init(person: Person, moc: NSManagedObjectContext){
        self.person = person
        super.init(moc: moc)
    }
    
    internal override func performFetchRequest()->NSFetchedResultsController{
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.moc!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // nadefinuji predikat
        // limit results to last 30 days and a concrete person
        let cal = NSCalendar.currentCalendar()
        let startDate = cal.dateByAddingUnit(.Day, value: -30, toDate: NSDate(), options: [])
        let teamPredicate = NSPredicate(format: "person.name like %@ AND timeStamp >= %@", person!.name!, startDate!)
        fetchRequest.predicate = teamPredicate
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.moc!, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return fetchedResultsController
    }

}
