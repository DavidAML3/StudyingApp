//
//  basicStudyingAppTests.swift
//  basicStudyingAppTests
//
//  Created by David Andres Mejia Lopez on 23/10/24.
//

import Testing
@testable import basicStudyingApp

struct basicStudyingAppTests {
    @Test("TaskViewModel loads tasks correctly") func fetchTasks() {
        let mockService = MockTaskService()
        let viewModel = TaskViewModel(taskService: mockService)
        viewModel.fetchTasks()
        #expect(viewModel.tasks.count == 2)
    }
}
