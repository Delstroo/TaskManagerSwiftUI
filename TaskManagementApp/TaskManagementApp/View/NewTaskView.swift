//
//  NewTaskView.swift
//  TaskManagementApp
//
//  Created by Delstun McCray on 7/31/23.
//

import SwiftUI

struct NewTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var taskTitle: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskColor: String = "task1"
    
    let colors: [String] = (1...8).compactMap { index -> String in
        return "task\(index)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            })
            .padding(.leading, -2)
            .padding(.top)

            VStack(alignment: .leading, spacing: 8) {
                Text("Task Title")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                TextField("Go for a walk!", text: $taskTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: RoundedRectangle(cornerRadius: 10))
            }
            .padding(.top, 5)
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Task Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    DatePicker("", selection: $taskDate)
                        .datePickerStyle(.compact)
                        .scaleEffect(0.9, anchor: .leading)
                        .labelsHidden()
                }
                .padding(.top, 5)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Task Color")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    ColorCirclesRow(colors: colors, selectedColor: $taskColor)
                }
            }
            .padding(.top, 5)
            .padding([.leading, .trailing], -8)
            Spacer(minLength: 0)
            
            Button(action: {
                let task = Task(taskTitle: taskTitle, creationDate: taskDate, tint: taskColor)
                do {
                    context.insert(task)
                    try context.save()
                    
                    dismiss()
                } catch {
                    print(error.localizedDescription)
                }
            }, label: {
                Text("Create Task")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .hSpacing(.center)
                    .padding(.vertical, 12)
                    .background(Color(taskColor), in: RoundedRectangle(cornerRadius: 12))
            })
            .disabled(taskTitle.isEmpty)
            .opacity(taskTitle.isEmpty ? 0.5 : 1)
        }
        .padding(15)
    }
}

struct ColorCirclesRow: View {
    let colors: [String]
    @Binding var selectedColor: String
    
    var body: some View {
        VStack {
            HStack(spacing: -10) {
                ForEach(colors.prefix(colors.count/2), id: \.self) { color in
                    CircleView(color: color, selectedColor: $selectedColor)
                }
            }
            
            HStack(spacing: -10) {
                ForEach(colors.suffix(from: colors.count/2), id: \.self) { color in
                    CircleView(color: color, selectedColor: $selectedColor)
                }
            }
        }
        .frame(width: 100)
    }
}

struct CircleView: View {
    let color: String
    @Binding var selectedColor: String
    
    var body: some View {
        Circle()
            .fill(Color(color))
            .frame(width: 20, height: 20)
            .background(
                Circle()
                    .stroke(lineWidth: 2)
                    .opacity(selectedColor == color ? 1 : 0)
            )
            .padding(.horizontal)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.linear) {
                    selectedColor = color
                }
            }
    }
}


struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView()
            .vSpacing(.bottom)
    }
}
