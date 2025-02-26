//
//  DoTaskApp.swift
//  DoTask
//
//  Created by Ranzyah Adinata Aldo on 09/02/25.
//

import SwiftUI

@main
struct DoTask: App {
    let persistenceController = PersistenceController.shared
    let viewContext = PersistenceController.shared.container.viewContext

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, viewContext)
        }
    }
}
