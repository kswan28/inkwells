

import SwiftUI
import Lottie

struct LoadingScreen: View {
    
    @Binding var opacity: Double
    
    
    var body: some View {
        LottieView(animation: .named("inkwell"))
            .looping()
            .opacity(opacity)
    }
    
    
    
    
}
