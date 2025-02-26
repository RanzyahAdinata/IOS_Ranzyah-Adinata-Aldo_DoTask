//
//  AddTaskModel.swift
//  DoTask
//
//  Created by Ranzyah Adinata Aldo on 09/02/25.
//

import Foundation
import CoreData

class AddTaskViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var deadline: Date = Date()
    @Published var description: String = ""
    @Published var selectedLevel: String = ""

    let levels = ["Low", "Medium", "High"]
    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

    func addTask(completion: @escaping (Bool) -> Void) {
        let newTask = Task(context: viewContext)
        newTask.id = UUID()
        newTask.title = title
        newTask.deadline = deadline
        newTask.level = selectedLevel
        newTask.descriptions = description
        newTask.isFinished = false

        do {
            try viewContext.save()
            completion(true) // Beri sinyal bahwa task berhasil ditambahkan
        } catch {
            print("Failed to save task: \(error.localizedDescription)")
            completion(false) // Indikasi error
        }
    }
}

