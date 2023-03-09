//
//  ToDoListTask+CoreDataProperties.swift
//  ToDo List
//
//  Created by Mac on 09/03/2023.
//  Copyright © 2023 mssvrk. All rights reserved.
//
//

import Foundation
import CoreData


extension ToDoListTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListTask> {
        return NSFetchRequest<ToDoListTask>(entityName: "ToDoListTask")
    }

    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var isDone: Bool
    @NSManaged public var name: String?

}
