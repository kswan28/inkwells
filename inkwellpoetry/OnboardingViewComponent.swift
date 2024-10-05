//
//  OnboardingViewComponent.swift
//  somethingGreat
//
//  Created by Kristen Swanson on 6/21/24.
//

import SwiftUI

struct OnboardingViewComponent: View {
    
    var onboardingImage: String
    var onboardingHeadline: String
    var onboardingSubheadline: String
    var buttonAction: () -> Void
    
    
    var body: some View {
        ZStack {
            Color.lavender
            
            VStack (alignment: .center) {
                Image(onboardingImage)
                    .resizable()
                    .frame(width: 320, height:320)
                Text(onboardingHeadline)
                    .font(.screenHeading)
                    .foregroundStyle(.darkNavy)
                    .padding(.top, 24)
                Text(onboardingSubheadline)
                    .font(.onboardingText)
                    .foregroundStyle(.darkNavy)
                    .padding(.top, 2)
                    .frame(width: 320)
                Button(action: {
                    buttonAction()
                }, label: {
                    ZStack{
                        Circle()
                            .foregroundColor(.allwhite)
                            .frame(width: 48)
                        Image(systemName: "arrow.forward")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 24)
                            .foregroundColor(.darkNavy)
                    }
                    .padding(.top, 48)
                })
            }
        }
    }
}
