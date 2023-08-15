//
//  TaskManagementAppApp.swift
//  TaskManagementApp
//
//  Created by Delstun McCray on 7/28/23.
//

import SwiftUI

@main
struct TaskManagementAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Task.self)
    }
}
