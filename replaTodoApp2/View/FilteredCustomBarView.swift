//
//  FilteredCustomBarView.swift
//  replaTodoApp2
//
//  Created by Alper Sülün on 17.08.2022.
//


import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View,T>: View where T: NSManagedObject {
    
    //MARK: Core Data Request
    @FetchRequest var request: FetchedResults<T>
    let content: (T)->Content
    
    //MARK: Building Custom ForEach which will give Coredata object to build View
    init(currentTab: String, @ViewBuilder content: @escaping (T)->Content) {
        
        //MARK: Predicate to Filter current date Tasks
        let calendar = Calendar.current
        var predicate: NSPredicate!
        
        if currentTab == "Today" {
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
            
            //Filter key
            let filterKey = "deadline"
            
            //This will fetch tasks between today and tomorrow which is 24 hours
            //0-false, 1-true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])
        } else if currentTab == "Upcoming" {
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tomorrow = Date.distantFuture
            
            //Filter key
            let filterKey = "deadline"
            
            //This will fetch tasks between tomorrow and future
            //0-false, 1-true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])
        } else if currentTab == "Failed" {
            let today = calendar.startOfDay(for: Date())
            let past = Date.distantPast
            
            //Filter key
            let filterKey = "deadline"
            
            //This will fetch failed tasks between past and today
            //0-false, 1-true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [past, today, 0])

        } else {
            //This will fetch done tasks
            //0-false, 1-true
            predicate = NSPredicate(format: "isCompleted == %i", argumentArray: [1])

        }
        
        // Initializing Request With NSPredicate
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [], predicate: predicate)
        self.content = content
        
    }
    
    var body: some View {
        Group {
            if request.isEmpty {
                Text("No tasks found!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id: \.objectID) { object in
                    self.content(object)
                }
            }
        }
    }
}
