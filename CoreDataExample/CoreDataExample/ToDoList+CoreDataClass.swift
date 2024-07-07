//
//  ToDoList+CoreDataClass.swift
//  CoreDataExample
//
//  Created by Harsha Agarwal on 03/05/24.
//
//

import Foundation
import CoreData

@objc(ToDoList)
public class ToDoList: NSManagedObject {

}

import UIKit
import CoreData

// Define a Core Data model
class User: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var age: Int16
}

// Core Data stack setup
lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "DataModel")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()

// Managed Object Context
let context = persistentContainer.viewContext

// Function to add a new user
func addUser(name: String, age: Int16) {
    let newUser = User(context: context)
    newUser.name = name
    newUser.age = age
    
    do {
        try context.save()
        print("User added successfully!")
    } catch {
        print("Error adding user: \(error)")
    }
}

// Function to fetch all users using NSFetchedResultsController
func fetchUsersWithResultsController() -> NSFetchedResultsController<User> {
    let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
    
    do {
        try fetchedResultsController.performFetch()
        return fetchedResultsController
    } catch {
        fatalError("Error fetching users with NSFetchedResultsController: \(error)")
    }
}

// Example usage with NSFetchedResultsController
addUser(name: "Alice", age: 25)
addUser(name: "Bob", age: 30)

let fetchedResultsController = fetchUsersWithResultsController()

if let users = fetchedResultsController.fetchedObjects {
    for user in users {
        print("Name: \(user.name), Age: \(user.age)")
    }
}
