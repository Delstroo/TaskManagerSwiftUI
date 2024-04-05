//
//  View+Extensions.swift
//  TaskManagementApp
//
//  Created by Delstun McCray on 7/28/23.
//

import SwiftUI

///Custom View Extensions

extension View {
    
    @ViewBuilder
    func hSpacing(_ alightment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alightment)
    }
    
    @ViewBuilder
    func vSpacing(_ alightment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alightment)
    }
    
    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    @ViewBuilder
    func background<Content: View>(@ViewBuilder contentOf backgroundContent: @escaping () -> Content) -> some View {
        self.background(backgroundContent())
    }
}

extension Font {
    static var secondary: Font {
        return Font.system(size: 12) // Modify the size or style as per your preference
    }
}

extension Color {
    static let offWhite = Color("offWhite")
    static let hintColor = Color(UserDefaults.standard.string(forKey: "hintColor") ?? "darkBlue")
    static let task1 = Color("task1")
    static let task2 = Color("task2")
    static let task3 = Color("task3")
    static let task4 = Color("task4")
    static let task5 = Color("task5")
    static let task6 = Color("task6")
    static let task7 = Color("task7")
    static let task8 = Color("task8")

}
