//
//  basicStudyingAppApp.swift
//  basicStudyingApp
//
//  Created by David Andres Mejia Lopez on 23/10/24.
//

import SwiftUI

@main
struct basicStudyingAppApp: App {
    var body: some Scene {
        WindowGroup {
            let taskService = TaskService()
            let viewModel = TaskViewModel(taskService: taskService)
            TaskListView(viewModel: viewModel)
        }
    }
}
