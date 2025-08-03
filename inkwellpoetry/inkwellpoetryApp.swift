//
//  inkwellpoetryApp.swift
//  inkwellpoetry
//
//  Created by Kristen Swanson on 9/2/24.
//

import SwiftUI
import UserNotifications
import TelemetryDeck
import MijickPopupView

//App Delegate to help handle notifications
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = CustomPopupSceneDelegate.self
        return sceneConfig
    }
}

class CustomPopupSceneDelegate: PopupSceneDelegate {
    override init() {
        super.init()
        config = { $0
            .centre { $0
                .tapOutsideToDismiss(true)
            }
        }
    }
}

@main
struct inkwellpoetryApp: App {
    
    @State private var isLoading = true
    @State private var opacity = 1.0
    @AppStorage("onboarding") var needsOnboarding = true
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        guard let appID = Bundle.main.infoDictionary?["TelemetryDeckAppID"] as? String else {
            fatalError("TelemetryDeck App ID not found in configuration")
        }
        let config = TelemetryDeck.Config(appID: appID)
        TelemetryDeck.initialize(config: config)
    }
    
    var body: some Scene {
        WindowGroup {
            
            ZStack{
                if isLoading {
                    LoadingScreen(opacity:$opacity)
                        .onAppear {
                                                 // Simulate loading delay
                                                 DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                     withAnimation(.easeOut(duration: 1.5)) {
                                                         opacity = 0 // Fade out the loading screen over 1.5 seconds
                                                     }
                                                     
                                                     // Set isLoading to false after the fade-out animation
                                                     DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                         isLoading = false
                                                     }
                                                 }
                                             }
                } else {
                    ContentView()
                        .implementPopupView()
                        .modelContainer(for: [InkwellEntryModel.self, Reminder.self, CustomPuzzleSettingsModel.self])
                        .onAppear {
                            
                            TelemetryDeck.signal("App.launched")
                            
                            // For the support email content, this suppresses constraint warnings
                            UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                            print(UIDevice.current.systemVersion)
                            print(UIDevice.current.modelName)
                            print(Bundle.main.displayName)
                            print(Bundle.main.appVersion)
                            print(Bundle.main.appBuild)
                            
                        }
                    
                    // Show OnboardingView if onboarding is needed
                    if needsOnboarding {
                        OnboardingView(needsOnboarding: $needsOnboarding)
                    }
                }
            }
        }
    }
}

