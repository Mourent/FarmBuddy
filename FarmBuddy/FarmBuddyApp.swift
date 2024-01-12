//
//  FarmBuddyApp.swift
//  FarmBuddy
//
//  Created by MacBook Pro on 10/01/24.
//

//import SwiftUI
//
//@main
//struct FarmBuddyApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

import SwiftUI

@main
struct FarmBuddyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
