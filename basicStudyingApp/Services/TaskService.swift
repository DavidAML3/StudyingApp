//
//  TaskService.swift
//  basicStudyingApp
//
//  Created by David Andres Mejia Lopez on 23/10/24.
//

import Foundation
import Combine
import os

protocol TaskServiceProtocol {
    func fetchTasks() -> AnyPublisher<[ToDoTask], Error>
    func fetchTasksConcurrency() async throws -> [ToDoTask]
}

let networkLogger = Logger(subsystem: "daml.basicStudyingApp", category: "networking")

class TaskService: TaskServiceProtocol {
    // Combine
    func fetchTasks() -> AnyPublisher<[ToDoTask], Error> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        
        networkLogger.log("Starting network request to: \(url.absoluteString, privacy: .public)")
        
        return URLSession.shared.dataTaskPublisher(for: url)
//            .map { $0.data }
            .tryMap { (data, response) in
                networkLogger.log("Received data from network request")
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    networkLogger.log("Invalid response: \(response.debugDescription, privacy: .public)")
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [ToDoTask].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    networkLogger.log("Network request failed: \(error.localizedDescription, privacy: .public)")
                } else {
                    networkLogger.log("Network request completed successfully")
                }
            })
            .eraseToAnyPublisher()
    }
    
    // Structured Concurrency
    func fetchTasksConcurrency() async throws -> [ToDoTask] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        
        networkLogger.log("Fetching tasks from \(url.absoluteString, privacy: .public)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        networkLogger.log("Successfully fetched tasks")
        
        let tasks = try JSONDecoder().decode([ToDoTask].self, from: data)
        return tasks
    }
}
