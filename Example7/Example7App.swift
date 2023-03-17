//
//  Example7App.swift
//  Example7
//
//  Created by 夏能啟 on 2023/3/17.
//

import SwiftUI

@main
struct Example7App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
