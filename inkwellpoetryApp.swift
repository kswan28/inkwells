@main
struct inkwellpoetryApp: App {
    @State private var isLoading = true
    @State private var opacity = 1.0
    @State private var contentViewOpacity = 0.0
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoading {
                    LoadingScreen(opacity: $opacity)
                        .onAppear {
                            // Simulate loading delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation(.easeOut(duration: 1.5)) {
                                    opacity = 0 // Fade out the loading screen over 1.5 seconds
                                }
                                
                                // Set isLoading to false after the fade-out animation
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    isLoading = false
                                    // Start fading in the ContentView
                                    withAnimation(.easeIn(duration: 1.0)) {
                                        contentViewOpacity = 1.0
                                    }
                                }
                            }
                        }
                } else {
                    ContentView()
                        .opacity(contentViewOpacity)
                        .implementPopupView()
                        .modelContainer(for: [InkwellEntryModel.self, Reminder.self, CustomPuzzleSettingsModel.self])
                        .onAppear {
                            // ... existing onAppear code ...
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
