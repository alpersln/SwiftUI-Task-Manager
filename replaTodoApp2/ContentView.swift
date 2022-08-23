//
//  ContentView.swift
//  replaTodoApp2
//
//  Created by Alper Sülün on 14.08.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @AppStorage("loginUsernameKey") var loginUsernameKey = ""
    @AppStorage("isLoggedIn") var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            Home()
        } else {
            GetUsernameView()
        }
        
//            Home()
//            .navigationBarTitle("Task Manager")
//            .navigationBarTitleDisplayMode(.inline)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
