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
                        AddNewTask()
                            .environmentObject(taskModel)
                    }
                }
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
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
