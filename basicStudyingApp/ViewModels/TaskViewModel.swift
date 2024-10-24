//
//  TaskViewModel.swift
//  basicStudyingApp
//
//  Created by David Andres Mejia Lopez on 23/10/24.
//

import Foundation
import Combine
import os

let viewModelLogger = Logger(subsystem: "daml.basicStudyingApp", category: "viewModel")

class TaskViewModel: ObservableObject {
    @Published var tasks: [ToDoTask] = []
    @Published var errorMessage: String?
    
    private let taskService: TaskServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(taskService: TaskServiceProtocol) {
        self.taskService = taskService
    }
    
    func fetchTasks() {
        viewModelLogger.log("Fetching tasks in TaskViewModel fetchTasks function")
        taskService.fetchTasks()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    viewModelLogger.log("Failed to fetch tasks: \(error.localizedDescription)")
                    self.errorMessage = "Failed to load tasks: \(error.localizedDescription)"
                case .finished:
                    viewModelLogger.log("Successfully completed task fetch")
                    break
                }
            } receiveValue: { [weak self] tasks in
                viewModelLogger.log("Received tasks successfully")
                self?.tasks = tasks
            }
            .store(in: &cancellables)
    }
    
    func fetchTasksConcurrency() {
        viewModelLogger.log("Fetching tasks in TaskViewModel fetchTasksConcurrency function")
        Task {
            do {
                let tasks = try await taskService.fetchTasksConcurrency()
                viewModelLogger.log("Successfully fetched tasks in TaskViewModel")
                DispatchQueue.main.async {
                    self.tasks = tasks
                }
            } catch(let error) {
                viewModelLogger.log("Failed to fetch tasks in TaskViewModel: \(error.localizedDescription)")
                self.errorMessage = "Error fetching tasks: \(error.localizedDescription)"
            }
        }
    }
}
