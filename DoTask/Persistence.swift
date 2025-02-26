//
//  Persistence.swift
//  DoTask
//
//  Created by Ranzyah Adinata Aldo on 09/02/25.
//

//
//  Persistence.swift
//  DoTask-TubesMotion
//
//  Created by Ranzyah Adinata Aldo on 08/02/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DoTask") // Pastikan sesuai dengan nama .xcdatamodeld
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("❌ Failed to load Core Data stack: \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    var context: NSManagedObjectContext {
        return container.viewContext
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("❌ Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }


    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext

        let sampleTask = Task(context: context)
        sampleTask.id = UUID()
        sampleTask.title = "Sample Task"
        sampleTask.deadline = Date()
        sampleTask.level = "High"
        sampleTask.descriptions = "This is a sample task for preview."
        sampleTask.isFinished = false
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            print("❌ Failed to save preview data: \(nsError), \(nsError.userInfo)")
        }
        
        return controller
    }()
}
