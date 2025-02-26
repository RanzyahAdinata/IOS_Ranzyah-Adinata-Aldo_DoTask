//
//  TaskDetailViewModel.swift
//  DoTask
//
//  Created by Ranzyah Adinata Aldo on 09/02/25.
//

import SwiftUI
import CoreData

class TaskDetailViewModel: ObservableObject {
    @Published var editedTitle: String
    @Published var editedDeadline: Date
    @Published var editedDescription: String
    @Published var editedLevel: String
    @Published var isEditing = false
    
    private var task: Task
    private var viewContext: NSManagedObjectContext
    
    init(task: Task, context: NSManagedObjectContext) {
        self.task = task
        self.viewContext = context
        self.editedTitle = task.title ?? ""
        self.editedDeadline = task.deadline ?? Date()
        self.editedDescription = task.descriptions ?? ""
        self.editedLevel = task.level ?? "Medium"
    }
    
    func saveChanges() {
        objectWillChange.send() 
        task.title = editedTitle
        task.deadline = editedDeadline
        task.level = editedLevel
        task.descriptions = editedDescription
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save task: \(error.localizedDescription)")
        }
        
        isEditing = false
    }
    
    func cancelEditing() {
        isEditing = false
    }
}
