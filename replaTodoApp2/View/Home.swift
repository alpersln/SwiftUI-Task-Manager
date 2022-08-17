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
                
                Text("Welcome Alper!")
                    .font(.title2.bold())

                CustomBar()
                    .padding()
                HStack {
                    Text("Tasks")
                        .font(.largeTitle.weight(.bold))
                    Spacer()
                    
                    Button {
                        isShowingSheet.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill").font(.system(size: 32.0))
                    }
                    
                    .sheet(isPresented: $isShowingSheet) {
                     //   taskModel.resetData
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
    
    @ViewBuilder
    func TaskView()->some View{
        LazyVStack(spacing:20){
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
                
                if !task.isCompleted{
                    Button{
                        taskModel.editTask = task
                        isShowingSheet.toggle()
                 //       taskModel.openEditTask = true
                        taskModel.setupTask()
                    }label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }
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
