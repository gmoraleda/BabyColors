//
//  BabyColorsApp.swift
//  BabyColors WatchKit Extension
//
//  Created by Guillermo Moraleda on 16.11.20.
//

import SwiftUI

@main
struct BabyColorsApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
