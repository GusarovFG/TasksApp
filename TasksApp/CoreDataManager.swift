//
//  CoreDataManager.swift
//  TasksApp
//
//  Created by Фаддей Гусаров on 19.04.2022.
//
import CoreData
import Foundation
import UIKit


class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init(){}
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "TasksApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

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
    
    //MARK: - Core Data fetching data
    
    func fetchTasks() -> [Task] {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let tasks = (try? self.persistentContainer.viewContext.fetch(fetchRequest)) ?? []
        
        return tasks
    }
    
    //MARK: - Core Data saving data
    
    func saveTask(title: String, text: String, image: UIImage) {
        
        let task = Task(context: self.persistentContainer.viewContext)
        let imageData = UIImage.pngData(image)
        
        task.title = title
        task.text = text
        task.images = imageData()
        task.creationDate = DateManager.shared.getDate()
        
        saveContext()
    }
    
    //MARK: - Core Data delete data

    func deleteTask(index: Int) {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let tasks = (try? self.persistentContainer.viewContext.fetch(fetchRequest)) ?? []
        
        self.persistentContainer.viewContext.delete(tasks[index])
        
        saveContext()
    }
    
    //MARK: - Core Data edit data
    
    func editTask(index: Int, task: Task) {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        var tasks = (try? self.persistentContainer.viewContext.fetch(fetchRequest)) ?? []
        
        tasks[index] = task
        tasks[index].editDate = DateManager.shared.getDate()
        
        saveContext()
    }
}


