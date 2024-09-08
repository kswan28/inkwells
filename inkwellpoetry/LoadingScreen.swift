

import SwiftUI
import Lottie

struct LoadingScreen: View {
    
    @State private var randomAnimation: String = ""
    
    
    var body: some View {
        LottieView(animation: .named("inkwell"))
            .looping()
    }
    
    
    
    
}
