//
//  replaTodoApp2App.swift
//  replaTodoApp2
//
//  Created by Alper Sülün on 14.08.2022.
//

import SwiftUI

@main
struct replaTodoApp2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
