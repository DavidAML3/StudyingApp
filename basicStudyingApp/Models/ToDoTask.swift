//
//  Task.swift
//  basicStudyingApp
//
//  Created by David Andres Mejia Lopez on 23/10/24.
//

import Foundation

struct ToDoTask: Identifiable, Codable {
    let id: Int
    let title: String
    let completed: Bool
}
