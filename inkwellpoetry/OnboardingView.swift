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
                    Color.lavender
                    
                    TabView(selection: $selectedOnboardingView) {
                        
                        OnboardingViewComponent(onboardingImage: "onboarding1", onboardingHeadline: "Welcome to Inkwell!", onboardingSubheadline: "Inkwells spark your creativity every day.", buttonAction: {
                            withAnimation {
                                selectedOnboardingView = 1
                            }
                        })
                        .tag(0)
                        .ignoresSafeArea()
                        
                        OnboardingViewComponent(onboardingImage: "onboarding2", onboardingHeadline: "To play:", onboardingSubheadline: "Explore the words until you make a poem or lyric you like.", buttonAction: {
                            withAnimation {
                                selectedOnboardingView = 2
                            }
                        })
                        .tag(1)
                        .ignoresSafeArea()
                        
                        OnboardingViewComponent(onboardingImage: "onboarding3", onboardingHeadline: "To finish:", onboardingSubheadline: "Push any words you don't need to the bottom of the screen.", buttonAction: {
                            withAnimation {
                                selectedOnboardingView = 3
                            }
                        })
                        .tag(2)
                        .ignoresSafeArea()
                        
                        OnboardingViewComponent(onboardingImage: "onboarding4", onboardingHeadline: "Share!", onboardingSubheadline: "Share your masterpiece with friends each day. #Inkwells", buttonAction: {
                            withAnimation {
                                needsOnboarding = false
                                dismiss()
                            }
                        })
                        .tag(3)
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
                            Circle()
                                .frame(width: 10)
                                .foregroundStyle(selectedOnboardingView == 3 ? .darkNavy: .gray)
                            Spacer()
                        }
                        .padding(.bottom, 120)
                    }
                }
                .ignoresSafeArea()
                }
            }
        }

