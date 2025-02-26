//
//  ContentViewModel.swift
//  DoTask
//
//  Created by Ranzyah Adinata Aldo on 09/02/25.
//


import Foundation
import CoreData

class ContentViewModel: ObservableObject {
    @Published var unfinishedTasks: [Task] = []
    @Published var finishedTasks: [Task] = []
    
    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchTasks()
    }

    func fetchTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Task.deadline, ascending: true)]

        do {
            let tasks = try viewContext.fetch(request)
            unfinishedTasks = tasks.filter { !$0.isFinished }
            finishedTasks = tasks.filter { $0.isFinished }
        } catch {
            print("Failed to fetch tasks: \(error.localizedDescription)")
        }
    }

    func markTaskAsFinished(task: Task) {
        task.isFinished = true
        saveContext()
    }

    func deleteTask(task: Task) {
        viewContext.delete(task)
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
            fetchTasks() // Refresh setelah menyimpan perubahan
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
