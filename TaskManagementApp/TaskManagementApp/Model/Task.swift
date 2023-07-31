//
//  Task.swift
//  TaskManagementApp
//
//  Created by Delstun McCray on 7/28/23.
//

import SwiftUI

struct Task: Identifiable {
    var id: UUID = .init()
    var taskTitle: String
    var creationDate: Date = .init()
    var isCompleted: Bool = false
    var tint: Color
}

var sampleTasks: [Task] = [
    .init(taskTitle: "Record Video", creationDate: .updateHour(-5), isCompleted: true, tint: .task1),
    .init(taskTitle: "Redesign Website", creationDate: .updateHour(-3), tint: .task2),
    .init(taskTitle: "Go for a Walk", creationDate: .updateHour(-4), tint: .task3),
    .init(taskTitle: "Edit Video", creationDate: .updateHour(0), isCompleted: true, tint: .task1),
    .init(taskTitle: "Publis Video", creationDate: .updateHour(2), isCompleted: true, tint: .task4),
    .init(taskTitle: "Tweet about new Video!", creationDate: .updateHour(1), tint: .task3)
    
]

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}
