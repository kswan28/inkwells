//
//  RadialGradientRectangle.swift
//  somethingGreat
//
//  Created by Kristen Swanson on 8/4/24.
//

import SwiftUI

struct RadialGradientRectangle: View {
    
    var topColorRed: Double = 0.70
    var topColorGreen: Double = 0.90
    var topColorBlue: Double = 0.95
    var bottomColorRed: Double = 0.60
    var bottomColorGreen: Double = 0.85
    var bottomColorBlue: Double = 0.75
    
    
    
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: topColorRed, green: topColorGreen, blue: topColorBlue),  // Approximate color for the top
                    Color(red: bottomColorRed, green: bottomColorGreen, blue: bottomColorBlue)   // Approximate color for the bottom
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.9), // Transparent white
                    Color.clear               // Fully transparent
                ]),
                center: .bottomLeading,
                startRadius: 5,
                endRadius: 400
            )
            .blendMode(.overlay)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    RadialGradientRectangle()
}




        
    



