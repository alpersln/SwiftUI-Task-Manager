//
//  ContentView.swift
//  replaTodoApp2
//
//  Created by Alper Sülün on 14.08.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
            Home()
            .navigationBarTitle("Task Manager")
            .navigationBarTitleDisplayMode(.inline)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
