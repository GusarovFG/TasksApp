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
    
    func saveTask(title: String?, text: String?, images: [UIImage], creationDate: String?) {
        
        let task = Task(context: self.persistentContainer.viewContext)
        task.creationDate = creationDate
        task.text = text
        task.title = title
        DispatchQueue.global(qos: .background).sync {
            task.images = saveImages(images: images)
        }
        
        saveContext()
    }
    
    //MARK: - CoreData saving array of UIImages to CoreData
    func saveImages(images: [UIImage]) -> Data? {
        return coreDataObjectFromImages(images: images)
    }
    
    func coreDataObjectFromImages(images: [UIImage]) -> Data? {
        let dataArray = NSMutableArray()
        
            for img in images {
                if let data = img.jpegData(compressionQuality: 0.3) {
                    dataArray.add(data)
                }
            }
        
        
        return try? NSKeyedArchiver.archivedData(withRootObject: dataArray, requiringSecureCoding: true)
    }
    
    func imagesFromCoreData(taskImages: Data?) -> [UIImage]? {
        var retVal = [UIImage]()
        
        guard let object = taskImages else { return nil }
        if let dataArray = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: object) {
            for data in dataArray {
                if let data = data as? Data, let image = UIImage(data: data) {
                    retVal.append(image)
                }
            }
        }
        
        return retVal
    }
    //MARK: - Core Data delete data
    
    func deleteTask(index: Int) {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let tasks = (try? self.persistentContainer.viewContext.fetch(fetchRequest)) ?? []
        
        self.persistentContainer.viewContext.delete(tasks[index])
        
        saveContext()
    }
    
    func deleteAllTasks() {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let tasks = (try? self.persistentContainer.viewContext.fetch(fetchRequest))
        
        for task in tasks ?? [] {
            self.persistentContainer.viewContext.delete(task)
            saveContext()
        }
        
    }
    
    //MARK: - Core Data edit data
    
    func editTask(index: Int, title: String?, text: String?, images: Data?, editDate: String?) {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let tasks = (try? self.persistentContainer.viewContext.fetch(fetchRequest)) ?? []
        
        
        tasks[index].editDate = editDate
        tasks[index].text = text
        tasks[index].title = title
        tasks[index].images = images
        saveContext()
        
    }
}


