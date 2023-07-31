//
//  Home.swift
//  TaskManagementApp
//
//  Created by Delstun McCray on 7/28/23.
//

import SwiftUI

struct Home: View {
    ///Task Manager Properties
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    @State private var tasks: [Task] = sampleTasks.sorted(by: { $1.creationDate > $0.creationDate })
    @State private var createNewTask: Bool = false 
    /// Animation Namespace
    @Namespace private var animation
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView(currentDate: currentDate)
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    /// Tasks View
                    TasksView()
                }
                .padding(.horizontal) // Replace hSpacing with padding
                .padding(.vertical)   // Replace vSpacing with padding
            }
        }
        .padding(.top)
        .overlay(alignment: .bottomTrailing, content: {
            Button(action: {
                createNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 55, height: 55)
                    .background(Color.darkBlue.shadow(.drop(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)), in: Circle())
            })
            .padding(15)
        })
        .onAppear {
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()

                if let firstDate = currentWeek.first?.date {
                    weekSlider.append(firstDate.createPrevioustWeek())
                }

                weekSlider.append(currentWeek) // Use `contentsOf` to append an array

                if let lastDate = currentWeek.last?.date {
                    weekSlider.append(lastDate.createNextWeek())
                }
            }
        }
        .sheet(isPresented: $createNewTask) { 
            NewTaskView()
                .presentationDetents([.height(300)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
                .presentationBackground(Color.offWhite)
        }
    }

    
    @ViewBuilder
    func headerView(currentDate: Date) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Text(currentDate.format("MMMM"))
                    .foregroundColor(.darkBlue)
                
                Text(currentDate.format("YYYY"))
                    .foregroundColor(.gray)
            }
            .font(.title.bold())
            
            Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            /// Week SLider
            TabView(selection: $currentWeekIndex) { 
                ForEach(weekSlider.indices, id: \.self) { index in 
                    let week = weekSlider[index]   
                    weekView(week)
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
        }
        .hSpacing(.leading)
        .overlay(alignment: .topTrailing, content: { 
            Button(action: {}) {
                Image("pic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }
        })
        .padding(15)
        .background(.white)
        .onChange(of: currentWeekIndex) { newValue in
            /// Creating when it reaches first/last pages
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
    }
    
    //week view
    @ViewBuilder
    func weekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 8) {
                    Text(day.date.format("E"))
                        .font(.secondary)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                    
                    Text(day.date.format("dd"))
                        .font(.secondary)
                        .fontWeight(.medium)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .gray)
                        .frame(width: 35, height: 35)
                        .background {
                            ZStack {
                                if isSameDate(day.date, currentDate) {
                                    Circle()
                                        .fill(Color.darkBlue)
//                                        .matchedGeometryEffect(id: "INDICATOR", in: animation)
                                }
                                
                                if day.date.isToday {
                                    Circle()
                                        .fill(.cyan)
                                        .frame(width: 5, height: 5)
                                        .offset(y: 11)
                                }
                            }
                        }
                        .background(Color.white.shadow(.drop(radius: 6)))
                        .clipShape(Circle()) // Clip the background to a circle shape
                    
                    //indeicator to show whis is today's date
                    //                    z
                }
                .hSpacing(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.linear ) {
                        currentDate = day.date
                    }
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        /// When the offset reaches 15 and if the createweek is toggled then simply generate next set of week
                        if value.rounded() == 15 && createWeek {
                            pageinateWeek()
                            createWeek = false
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    func TasksView() -> some View {
        VStack(alignment: .leading, spacing: 35) { 
            ForEach($tasks) { $task in 
                TaskRowView(task: $task)
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
    }
    
    func pageinateWeek() {
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                weekSlider.insert(firstDate.createPrevioustWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == weekSlider.count - 1 {
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
