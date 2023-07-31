//
//  NewTaskView.swift
//  TaskManagementApp
//
//  Created by Delstun McCray on 7/31/23.
//

import SwiftUI

struct NewTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var taskTitle: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskColor: Color = .accentColor
    var body: some View {
        VStack(alignment: .leading, spacing: 15) { 
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            })
            .hSpacing(.leading)
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
                }
                .padding(.top, 5)
                //Give some Space for tapping
                .padding(.trailing, -15)
                VStack(alignment: .leading, spacing: 8) { 
                    Text("Task Color")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    let colors: [Color] = [.task1, .task2, .task3, .task4]
                    HStack(spacing: 0) { 
                        ForEach(colors, id:\.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 20, height: 20)
                                .background(contentOf: { 
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .opacity(taskColor == color ? 1 : 0)
                                })
                                .hSpacing(.center)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.linear) {
                                        taskColor = color
                                    }
                                }
                        }
                    }
                }
            }
            .padding(.top, 5)
            Spacer(minLength: 0)
            Button(action: {}, label: {
                Text("Create Task")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .hSpacing(.center)
                    .padding(.vertical, 12)
                    .background(taskColor, in: RoundedRectangle(cornerRadius: 12))
            })
            .disabled(taskTitle == "")
            .opacity(taskTitle == "" ? 0.5 : 1)
        }
        .padding(15)
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView()
            .vSpacing(.bottom)
    }
}
