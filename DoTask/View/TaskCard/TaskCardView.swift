//
//  TaskCardView.swift
//  DoTask
//
//  Created by Ranzyah Adinata Aldo on 09/02/25.
//
import SwiftUI
import CoreData

struct TaskCardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var task: Task
    let markAsFinished: (Task) -> Void
    let deleteTask: (Task) -> Void
    @State private var showDeleteAlert = false
    @State private var isShowingDetail = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title
            HStack {
                Text(task.title ?? "Untitled Task")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }

            HStack {
                Text(task.level ?? "Medium")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(getLevelColor())
                    .cornerRadius(25)
                
                Text("Deadline: \(formattedDate(task.deadline))")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("Description")
                    .font(.system(size: 16, weight: .bold))

                Text(task.descriptions ?? "No description available")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }

            HStack {
                Button(action: {
                    isShowingDetail = true
                }) {
                    Text("Detail")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 120, height: 40)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isShowingDetail) {
                    TaskDetailView(viewModel: TaskDetailViewModel(task: task, context: viewContext))
                        .onDisappear {
                            try? viewContext.save()                         }
                }

                Spacer()

                Button(action: {
                    showDeleteAlert = true
                }) {
                    Image(systemName: "trash.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.red)
                }
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text("Delete Task"),
                        message: Text("Are you sure you want to delete this task?"),
                        primaryButton: .destructive(Text("Delete")) {
                            deleteTask(task)
                        },
                        secondaryButton: .cancel()
                    )
                }

                if !task.isFinished {
                    Button(action: {
                        markAsFinished(task)
                    }) {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 25, height: 20)
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Helper Functions
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "No deadline" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy - h:mm a"
        return formatter.string(from: date)
    }

    private func getLevelColor() -> Color {
        switch task.level {
        case "High": return .red
        case "Medium": return .orange
        case "Low": return .blue
        default: return .gray
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let sampleTask = Task(context: context)
    sampleTask.id = UUID()
    sampleTask.title = "Sample Task"
    sampleTask.deadline = Date()
    sampleTask.level = "High"
    sampleTask.descriptions = "This is a sample task for preview."
    sampleTask.isFinished = false
    
    return TaskCardView(
        task: sampleTask,
        markAsFinished: { _ in },
        deleteTask: { _ in }
    )
}


