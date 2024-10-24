//
//  ContentView.swift
//  basicStudyingApp
//
//  Created by David Andres Mejia Lopez on 23/10/24.
//

import SwiftUI
import os

let viewLogger = Logger(subsystem: "daml.basicStudyingApp", category: "view")

struct TaskListView: View {
    @StateObject var viewModel: TaskViewModel
    
    init(viewModel: TaskViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.tasks) { task in
                    TaskRow(task: task)
                }
            }
            .navigationTitle("My Tasks")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        // TODO: - create add function
                        viewLogger.log("Add task button tapped")
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .onAppear {
                viewLogger.log("TaskListView appeared")
                viewModel.fetchTasksConcurrency()
            }
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct TaskRow: View {
    let task: ToDoTask
    
    var body: some View {
        HStack {
            Text(task.title)
            Spacer()
            if task.completed {
                Image(systemName: "checkmark.circle")
                    .foregroundStyle(.green)
            } else {
                Image(systemName: "circle")
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    TaskListView(viewModel: TaskViewModel(taskService: MockTaskService()))
}
