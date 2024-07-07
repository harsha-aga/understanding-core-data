//
//  ToDoList+CoreDataProperties.swift
//  CoreDataExample
//
//  Created by Harsha Agarwal on 03/05/24.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var age: Int64

}

extension ToDoList : Identifiable {

}
