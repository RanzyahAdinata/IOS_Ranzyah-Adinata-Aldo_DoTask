//  TaskDetailView.swift
//  DoTask
//
//  Created by Ranzyah Adinata Aldo on 09/02/25.
//

import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var viewModel: TaskDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 20, height: 15)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Task Details")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                Button(action: {
                    viewModel.isEditing.toggle()
                }) {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Title").font(.headline)
                TextField("Title", text: $viewModel.editedTitle)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .disabled(!viewModel.isEditing)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Deadline").font(.headline)
                if viewModel.isEditing {
                    DatePicker("", selection: $viewModel.editedDeadline, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                } else {
                    Text(formattedDate(viewModel.editedDeadline))
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Level").font(.headline)
                HStack {
                    ForEach(["Low", "Medium", "High"], id: \.self) { level in
                        Text(level)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(viewModel.editedLevel == level ? .white : .black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(viewModel.editedLevel == level ? getLevelColor(level) : Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .onTapGesture {
                                if viewModel.isEditing {
                                    viewModel.editedLevel = level
                                }
                            }
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Descriptions").font(.headline)
                TextEditor(text: $viewModel.editedDescription)
                    .frame(height: 150)
                    .padding()
                    .background(Color.gray.opacity(0))
                    .cornerRadius(10)
                    .disabled(!viewModel.isEditing)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                    )
            }
            
            if viewModel.isEditing {
                HStack {
                    Button("Cancel") {
                        viewModel.cancelEditing()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("Save") {
                        viewModel.saveChanges()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "No deadline" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy, h:mm a"
        return formatter.string(from: date)
    }
    
    private func getLevelColor(_ level: String) -> Color {
        switch level {
        case "High": return .red.opacity(0.7)
        case "Medium": return .orange.opacity(0.7)
        case "Low": return .blue.opacity(0.7)
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
    sampleTask.level = ""
    sampleTask.descriptions = "This is a sample task description."
    sampleTask.isFinished = false
    
    return TaskDetailView(viewModel: TaskDetailViewModel(task: sampleTask, context: context))
}

