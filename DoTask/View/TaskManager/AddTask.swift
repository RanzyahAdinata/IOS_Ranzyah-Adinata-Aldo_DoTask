//
//  AddTask.swift
//  DoTask
//
//  Created by Ranzyah Adinata Aldo on 09/02/25.
//
//

import SwiftUI
import CoreData

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: AddTaskViewModel

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: AddTaskViewModel(context: context))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 20, height: 15)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Add Task")
                    .font(.system(size: 22, weight: .bold))
                Spacer()
            }
            .padding(.bottom, 10)

            // Title Input
            Text("Title")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            TextField("Enter task title", text: $viewModel.title)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

            // Deadline Input
            Text("Deadline")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            DatePicker("Select Deadline", selection: $viewModel.deadline, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

            // Level Selection
            Text("Level")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            HStack {
                ForEach(viewModel.levels, id: \.self) { level in
                    Button(action: { viewModel.selectedLevel = level }) {
                        Text(level)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(viewModel.selectedLevel == level ? .white : .gray)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(viewModel.selectedLevel == level ? Color.black : Color.gray.opacity(0.4))
                            .cornerRadius(10)
                    }
                }
            }


            Text("Descriptions")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
            TextEditor(text: $viewModel.description)
                .frame(height: 120)
                .padding()
                .background(Color.gray.opacity(0))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                )
            // Add Task Button
            Button(action: {
                viewModel.addTask { success in
                    if success {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }) {
                Text("Add")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            .padding(.top, 10)
            .disabled(viewModel.title.trimmingCharacters(in: .whitespaces).isEmpty)

            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    AddTaskView(context: PersistenceController.preview.container.viewContext)
}

