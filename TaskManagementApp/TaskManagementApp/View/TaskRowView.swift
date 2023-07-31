//
//  TaskRowView.swift
//  TaskManagementApp
//
//  Created by Delstun McCray on 7/31/23.
//

import SwiftUI

struct TaskRowView: View {
    @Binding var task: Task
    var body: some View {
        HStack(alignment: .top, spacing: 15) { 
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: 
                        Circle())
                .overlay {
                    Circle()
                        .frame(width: 50, height: 50, alignment: .center)
                        .blendMode(.destinationOver)
                        .onTapGesture {
                            withAnimation(.linear) {
                                task.isCompleted.toggle() 
                            }
                        }
                }
            
            VStack(alignment: .leading, spacing: 8) { 
                Text(task.taskTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                
                Label(task.creationDate.format("hh:mm a"), systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.black)
            }
            .padding(15)
            .hSpacing(.leading)
            .background(task.tint, in: RoundedRectangle(cornerRadius: 12))
            .strikethrough(task.isCompleted, pattern: .solid, color: .black)
            .offset(y: -8)
        }
    }
    
    var indicatorColor: Color {
        if task.isCompleted {
            return .green
        }
        return task.creationDate.isSameHour ? .darkBlue : (task.creationDate.isPast) ? .red : .black
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
