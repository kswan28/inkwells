import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var selectedOnboardingView = 0
    @Binding var needsOnboarding: Bool
    @State private var fadeOut = false
    @State private var showContentView = false
    
    var body: some View {
        ZStack {
//            if !fadeOut {
                ZStack {
                    RadialGradientRectangle()
                    
                    TabView(selection: $selectedOnboardingView) {
                        
                        OnboardingViewComponent(onboardingImage: "Onboarding1", onboardingHeadline: "When the journey ahead looks tough...", onboardingSubheadline: "", buttonAction: {
                            withAnimation {
                                selectedOnboardingView = 1
                            }
                        })
                        .tag(0)
                        .ignoresSafeArea()
                        
                        OnboardingViewComponent(onboardingImage: "Onboarding2", onboardingHeadline: "...remember how far you've come.", onboardingSubheadline: "(Phew, that's a long way!)", buttonAction: {
                            withAnimation {
                                selectedOnboardingView = 2
                            }
                        })
                        .tag(1)
                        .ignoresSafeArea()
                        
                        OnboardingViewComponent(onboardingImage: "Onboarding3", onboardingHeadline: "This app will save your wins along the way.", onboardingSubheadline: "(There's a lot to celebrate!)", buttonAction: {
                            withAnimation {
                                needsOnboarding = false
                                dismiss()
                            }
                        })
                        .tag(2)
                        .ignoresSafeArea()
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .ignoresSafeArea()
                    .transition(.opacity)
                    
                    VStack{
                        Spacer()
                        HStack (spacing: 16) {
                            Spacer()
                            Circle()
                                .frame(width: 10)
                                .foregroundStyle(selectedOnboardingView == 0 ? .darkNavy: .gray)
                            Circle()
                                .frame(width: 10)
                                .foregroundStyle(selectedOnboardingView == 1 ? .darkNavy: .gray)
                            Circle()
                                .frame(width: 10)
                                .foregroundStyle(selectedOnboardingView == 2 ? .darkNavy: .gray)
                            Spacer()
                        }
                        .padding(.bottom, 120)
                    }
                }
                .ignoresSafeArea()
                }
            }
        }

