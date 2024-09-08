//
//  inkwellpoetryApp.swift
//  inkwellpoetry
//
//  Created by Kristen Swanson on 9/2/24.
//

import SwiftUI
import UserNotifications

//App Delegate to help handle notifications
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}

@main
struct inkwellpoetryApp: App {
    
    @State private var isLoading = true
    
    var body: some Scene {
        WindowGroup {
            
            if isLoading {
                
                LoadingScreen()
                    .onAppear{
                        // Simulate loading delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            
                            withAnimation{
                                isLoading = false // Set loading to false after delay
                            }
                        }
                    }
            }
            
            else {
                ContentView()
                                  .modelContainer(for: [InkwellEntryModel.self, Reminder.self])
                                  .onAppear {
                                      // For the support email content, this suppresses constraint warnings
                                      UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                                      print(UIDevice.current.systemVersion)
                                      print(UIDevice.current.modelName)
                                      print(Bundle.main.displayName)
                                      print(Bundle.main.appVersion)
                                      print(Bundle.main.appBuild)
                                  }
                          }
            
        }
        
    }
}
