//
//  TasksView.swift
//  TaskManagementApp
//
//  Created by Delstun McCray on 8/14/23.
//

import SwiftUI
import SwiftData

struct TasksView: View {
    @Binding var currentDate: Date
    
    @Query private var tasks: [Task]
    init(currentDate: Binding<Date>) {
        self._currentDate = currentDate
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: currentDate.wrappedValue)
        let endOfDate = calendar.date(byAdding: .day, value: 1, to: startOfDate)!
        let predicate = #Predicate<Task> {
            return $0.creationDate >= startOfDate && $0.creationDate < endOfDate
        }
        
        let sortDescriptor = [
            SortDescriptor(\Task.creationDate, order: .reverse)
        ]
        
        self._tasks = Query(filter: predicate, sort: sortDescriptor, animation: .snappy)
    }
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 35) {
                ForEach(tasks) { task in
                    TaskRowView(task: task)
                        .background(alignment: .leading) {
                            if tasks.last?.id != task.id {
                                Rectangle()
                                    .frame(width: 1)
                                    .offset(x: 8)
                                    .padding(.bottom, -35)
                                    .foregroundColor(.black)
                            }
                        }
                }
            }
            .padding([.vertical, .leading], 15)
            .padding(.top, 15)
            
            if tasks.isEmpty {
                Text("No Tasks Found")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
