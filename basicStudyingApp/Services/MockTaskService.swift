//
//  MockTaskService.swift
//  basicStudyingApp
//
//  Created by David Andres Mejia Lopez on 23/10/24.
//

import Foundation
import Combine

class MockTaskService: TaskServiceProtocol {
    func fetchTasksConcurrency() async throws -> [ToDoTask] {
        return [
            ToDoTask(id: 1, title: "Test task 1", completed: false),
            ToDoTask(id: 2, title: "Test task 2", completed: true),
            ToDoTask(id: 3, title: "Test task 3", completed: true),
            ToDoTask(id: 4, title: "Test task 4", completed: false)
        ]
    }
    
    func fetchTasks() -> AnyPublisher<[ToDoTask], Error> {
        let tasks = [
            ToDoTask(id: 1, title: "Test task 1", completed: false),
            ToDoTask(id: 2, title: "Test task 2", completed: true)
        ]
        
        return Just(tasks)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
