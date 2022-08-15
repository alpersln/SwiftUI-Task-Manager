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
}
