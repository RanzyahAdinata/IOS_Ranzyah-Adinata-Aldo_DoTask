//
//  ContentView.swift
//  DoTask
//
//  Created by Ranzyah Adinata Aldo on 09/02/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ContentViewModel
    @StateObject private var userViewModel = UserViewModel()
    @State private var showAddTaskView = false
    @State private var selectedTab = "Unfinished"

    init() {
        _viewModel = StateObject(wrappedValue: ContentViewModel(context: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Welcome, \(userViewModel.selectedUser?.name ?? "Anonymous")")
                        .font(.system(size: 25, weight: .semibold))
                        .onAppear {
                            userViewModel.fetchUsers()
                        }
                    HStack(spacing: 2) {
                        Text("\(viewModel.unfinishedTasks.count)")
                            .foregroundColor(.red)
                            .font(.system(size: 15, weight: .bold))
                        Spacer().frame(width: 2)
                        Text("tasks are waiting for you today")
                            .font(.system(size: 15))
                    }
                    Spacer().frame(height: 20)
                    Picker("", selection: $selectedTab) {
                        Text("Unfinished").tag("Unfinished")
                        Text("Finished").tag("Finished")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()

                // Task List
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10) {
                        if selectedTab == "Unfinished" {
                            if viewModel.unfinishedTasks.isEmpty {
                                Text("No unfinished tasks")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                ForEach(viewModel.unfinishedTasks, id: \.id) { task in
                                    TaskCardView(task: task, markAsFinished: viewModel.markTaskAsFinished, deleteTask: viewModel.deleteTask)
                                }
                            }
                        } else {
                            if viewModel.finishedTasks.isEmpty {
                                Text("No finished tasks")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                ForEach(viewModel.finishedTasks, id: \.id) { task in
                                    TaskCardView(task: task, markAsFinished: viewModel.markTaskAsFinished, deleteTask: viewModel.deleteTask)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .top)
                }
                .frame(maxHeight: .infinity, alignment: .top)

                ZStack(alignment: .bottom) {
                    HStack {
                        Spacer()
                        Button(action: { }) {
                            Image(systemName: "house.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Button(action: { showAddTaskView.toggle() }) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(18)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .offset(y: -40)
                        .sheet(isPresented: $showAddTaskView, onDismiss: {
                            viewModel.fetchTasks()
                        }) {
                            AddTaskView(context: viewContext)
                        }
                        Spacer()

                        NavigationLink(destination: UserView()) {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
#Preview {
    let context = PersistenceController.preview.container.viewContext
    return ContentView()
        .environment(\.managedObjectContext, context)
}

