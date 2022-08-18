//
//  TaskViewModel.swift
//  replaTodoApp2
//
//  Created by Alper Sülün on 15.08.2022.
//

import CoreData
import SwiftUI

class TaskViewModel : ObservableObject {
    @Published var currentTab : String = "Today"
    
    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = ""
    @Published var taskDeadline: Date = Date()
    @Published var taskType: String = "Basic"
    @Published var showDatePicker: Bool = false
    
    @Published var editTask : Task?
    
    @Published var toggleCardMenu = false
    
    
    func addTask(context:NSManagedObjectContext) -> Bool{
        
        var task:Task!
//        if let editTask = editTask {
//            task = editTask
//        } else {
//            task = Task(context: context)
//        }
        if editTask != nil && openEditTask == true {
            task = editTask
        } else {
            task = Task(context: context)
        }
      
        task.title = taskTitle
        task.color = taskColor
        //== "" ? "Yellow" : taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false
        
        if let _ = try? context.save(){
            return true
        }
        return false
    }
    
    func resetData(){
        taskType = "Basic"
        taskColor = "Yellow"
        taskTitle = ""
        taskDeadline = Date()
        openEditTask = false
    }
    
    func setupTask(){
       
            if let editTask = editTask {
                taskType = editTask.type ?? "Basic"
                taskColor = editTask.color ?? "Pink"
                taskTitle = editTask.title ?? ""
                taskDeadline = editTask.deadline ?? Date()
            }
        


    }
    
}
