import SwiftUI
import Lottie

struct AnimationView: View {
    @Binding var isShowing: Bool
    var animationName: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            LottieView(animation: .named(animationName))
                .looping()
        }
        .opacity(isShowing ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: isShowing)
    }
}
