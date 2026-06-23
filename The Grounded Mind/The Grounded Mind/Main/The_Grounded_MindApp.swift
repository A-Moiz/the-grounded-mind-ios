//
//  The_Grounded_MindApp.swift
//  The Grounded Mind
//
//  Created by Abdul Moiz on 23/06/2026.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct The_Grounded_MindApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var dataManager = AppDataManager()
    
    var body: some Scene {
        WindowGroup {
            IntroView()
                .environment(dataManager)
                .task {
                    await dataManager.preloadAllData()
                }
        }
    }
}
