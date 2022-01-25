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
    private init() {}
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveTask(_ taskName: String, completion: @escaping([Task]) -> Void) {
        let context = persistentContainer.viewContext
        let task = Task(context: context)
        task.name = taskName
        var taskList: [Task] = []
        taskList.append(task)
        
        saveContext()
    }
    
    func fetchData(completion: @escaping([Task]) -> Void) {
        let fetchRequest = Task.fetchRequest()
        let context = persistentContainer.viewContext
        
        do {
            let taskList = try context.fetch(fetchRequest)
                completion(taskList)
        } catch {
           print("Faild to fetch data", error)
        }
    }
}
