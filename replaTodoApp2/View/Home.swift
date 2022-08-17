//
//  Home.swift
//  replaTodoApp2
//
//  Created by Alper Sülün on 14.08.2022.
//

import SwiftUI

struct Home: View {
    @StateObject var taskModel : TaskViewModel = .init()
    @Namespace var tabAnimation
    @State var isShowingSheet = false
    
    @Environment(\.self) var env
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath:\Task.deadline, ascending: false)], predicate: nil, animation: .easeInOut) var tasks: FetchedResults<Task>
    
    var body: some View {
        ScrollView {
            VStack(alignment:.leading,spacing: 8) {
                
                HStack{
                    Image(systemName: "person.fill")
                        
                        .resizable()
                        .frame(width:40, height: 40)
                        .background(RoundedRectangle(cornerRadius: 8).fill(.blue.opacity(0.7)))
                    Text("Hi, Duru")
                        .font(.largeTitle.weight(.semibold))
                        .padding()
                    Spacer()
                    

                }

                CustomBar()
                    .padding()
                HStack {
                    Text("Tasks")
                        .font(.title.weight(.bold))
                    Spacer()
//                    Button("delete"){
//                        taskModel.toggleCardMenu.toggle()
//                        print(taskModel.toggleCardMenu)
//                        
//                       
//                    }
                    Spacer()
                    Button {
                        taskModel.resetData()
                        isShowingSheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill").font(.system(size: 32.0))
                    }
                    
                    .sheet(isPresented: $isShowingSheet) {
                        
                        AddNewTask()
                            .environmentObject(taskModel)
                    }
                }
                
                TaskView()
            }                    .frame(maxWidth: .infinity, alignment: .leading)
                
        }
        .padding()
    }
    
    @ViewBuilder
    func CustomBar()->some View{
        let tabs = ["Today","Upcoming","Daily"]
        HStack(spacing:10){
            ForEach(tabs,id:\.self){  tab in
                Text(tab)
                
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.vertical,8)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(taskModel.currentTab == tab ? .yellow : .black)
                    .background{
                        if taskModel.currentTab == tab {
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: tabAnimation)
                        }
                    }.contentShape(Capsule())
                    .onTapGesture {
                        withAnimation{taskModel.currentTab = tab}
                    }
                
            }
        }
    }
    
    private func deleteItems2(_ item: Task) {
        if let ndx = tasks.firstIndex(of: item) {
            env.managedObjectContext.delete(tasks[ndx])
        do {
            try env.managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
      }
    }
    
    
    @ViewBuilder
    func TaskView()->some View{
        LazyVGrid(columns:[GridItem(),GridItem()]){
            DynamicFilteredView(currentTab: taskModel.currentTab){
                (task:Task) in
                TaskRowView(task: task)
            }
        }.padding()
    }
    
    @ViewBuilder
    func TaskRowView(task:Task)->some View{
        VStack(alignment:.leading, spacing: 20){
            HStack{
                Text(task.type ?? "")
                    .font(.callout)
                    .padding(.vertical,5)
                    .padding(.horizontal)
                    .background{
                        Capsule().fill(.white.opacity(0.3))
                    }
                Spacer()

                if taskModel.toggleCardMenu {




                }
                Spacer()
                
                Menu {
                                Button("Edit", action: {
                                    taskModel.editTask = task
                                    isShowingSheet.toggle()
                             //       taskModel.openEditTask = true
                                    taskModel.setupTask()
                                })
                                Button("Delete", action: {deleteItems2(task)})
                                Button("Cancel", action: {})
                            } label: {
                            Image(systemName: "square.and.pencil")
                                    
                                    .font(.system(size: 26.0, weight: .bold))
                                    .foregroundColor(.black)
                        }
            }
            Text(task.title ?? "")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical,10)
            HStack(alignment:.bottom,spacing: 0){
                VStack(alignment:.leading,spacing: 10){
                    Label{
                        Text((task.deadline ?? Date()).formatted(date: .long, time:.omitted))
                    } icon: {
                        Image(systemName: "calender")
                    }
                    .font(.caption)
                    Label{
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time:.shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }.font(.caption)
                }
                .frame(maxWidth:.infinity,alignment: .leading)
                
                if !task.isCompleted{
                    Button{
                        task.isCompleted.toggle()
                        try? env.managedObjectContext.save()
                    }label: {
                        Circle()
                            .strokeBorder(.black,lineWidth: 1.5)
                            .frame(width:25, height:25)
                            .contentShape(Circle())
                    }
                }
            }
        }.padding()
            .frame(maxWidth:.infinity)
            .background{
                RoundedRectangle(cornerRadius: 12,style: .continuous)
                    .fill(Color(task.color ?? "Pink"))
            }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
