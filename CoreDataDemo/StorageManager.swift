//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Vasichko Anna on 25.01.2022.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private let viewContext: NSManagedObjectContext
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    func saveContext () {
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveTask(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.name = taskName
        completion(task)
        saveContext()
    }
    
    func deleteTask(_ deletedTask: Task) {
        viewContext.delete(deletedTask)
        saveContext()
        
    }
    
    func editTask(_ editingTask: Task, newTaskName: String) {
        editingTask.name = newTaskName
        saveContext()
    }
    
    func fetchData(completion: ([Task]) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskList = try viewContext.fetch(fetchRequest)
                completion(taskList)
        } catch {
           print("Faild to fetch data", error)
        }
    }
}
