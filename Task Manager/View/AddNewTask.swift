//
//  AddNewTask.swift
//  replaTodoApp2
//
//  Created by Alper Sülün on 15.08.2022.
//

import SwiftUI

struct AddNewTask: View {
    @EnvironmentObject var taskModel:TaskViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.self) var env
    
    var body: some View {
        VStack(alignment:.leading,spacing: 12) {
            Text(taskModel.openEditTask ? "Edit Task" : "Add Task")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
            VStack(alignment:.leading){
                Text("Task Color")
                    .font(.caption)
                    .foregroundColor(.gray)
                let colors: [String] =
                ["Grey","Brown","DarkGreen","LightGreen","LightPurple","Orange","Pink","Purple","Red","Turquoise","Yellow"]
                HStack(spacing:10){
                    ForEach(colors, id: \.self){
                        color in
                        Circle()
                            .fill(Color(color))
                            .frame(width: 25, height: 25)
                            .background{
                                if taskModel.taskColor == color {
                                    Circle()
                                        .strokeBorder(.gray)
                                        .padding(-3)
                                }
                            }
                            .contentShape(Circle())
                            .onTapGesture {
                                taskModel.taskColor = color
                            }
                    }
                }.padding(.top,10)
            }            .frame(maxWidth:.infinity,alignment: .leading)
                .padding(.top,30)
            Divider()
                .padding(.vertical,10)
            VStack(alignment: .leading,spacing: 12){
                Text("Task Title")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("Enter Task",text: $taskModel.taskTitle)
                    .frame(maxWidth:.infinity)
                    .padding()
                    
            }
            
            
            Divider()
            VStack(alignment: .leading,spacing: 12){
                Text("Task Deadline")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(taskModel.taskDeadline.formatted(date:.abbreviated,time: .omitted)
                     + ", " + taskModel.taskDeadline.formatted(date: .omitted, time: .shortened))
                    .frame(maxWidth:.infinity)
                    .font(.callout.weight(.semibold))
                    //.padding()

            }.frame(maxWidth:.infinity,alignment: .leading)
            .overlay(alignment: .bottomTrailing){
                

                    Button{
                        taskModel.showDatePicker.toggle()
                        print(taskModel.showDatePicker)

                        print("calender pickk")
                    } label: {
                        Image(systemName: "calendar")
                            .foregroundColor(.black)
                            .font(.title2)
                }
            }
            //overlay m b h
            Divider()
            let taskTypes : [String] = ["Basic","Urgent","Important"]
            VStack(alignment: .leading,spacing: 12){
                Text("Task Type")
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack(spacing:12){
                    ForEach(taskTypes, id: \.self){
                        type in
                        Text(type)
                            .lineLimit(2)
                            .font(.callout)
                            .padding(.vertical,10)
                            .frame(maxWidth:.infinity)
                            .foregroundColor(taskModel.taskType == type ? .yellow : .black)
                            .background{
                                
                              if taskModel.taskType == type {
                                  Capsule().fill(.black)
                              } else {
                                  Capsule().strokeBorder(.gray)
                              }
     
                            }.onTapGesture {
                                withAnimation{taskModel.taskType = type}
                            }

                    }
                }.padding()
                    .frame(maxWidth:.infinity,alignment: .leading)
            }.frame(maxWidth:.infinity,alignment: .leading)
            Divider()
            
            Button{
                
                let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: taskModel.taskDeadline)
                guard let hour = dateComponents.hour, let minute = dateComponents.minute else { return }
                taskModel.createLocalNotification(title: taskModel.taskTitle, hour: hour, minute: minute) { error in
                    print(minute)
                    if error != nil {
                        print("error notific")
                    }
                }
                
                if taskModel.addTask(context: env.managedObjectContext){
                    
                    env.dismiss()
                }

            }label: {
                Text("Save")
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth:.infinity)
                    .background{
                        Capsule()
                            .fill(.black)
                            
                    }
            }.frame(maxHeight:.infinity, alignment: .bottom)
                .padding(.vertical,8)
              //  .disabled(taskModel.taskTitle == "")
            //    .opacity(taskModel.taskTitle == "" ? 0.6 : 1 )
        }
        .frame(maxWidth:.infinity,alignment: .leading)
        .padding()
        .overlay{
            if taskModel.showDatePicker {
                
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .onTapGesture{
                        taskModel.showDatePicker = false
                    }
                
                DatePicker.init("",selection: $taskModel.taskDeadline,in:Date.distantPast...Date.distantFuture).labelsHidden()
            }
        }
    }
}

struct AddNewTask_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTask()
            .environmentObject(TaskViewModel())
    }
}
