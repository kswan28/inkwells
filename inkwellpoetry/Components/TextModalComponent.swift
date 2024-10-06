//
//  TextModalComponent.swift
//  somethingGreat
//
//  Created by Kristen Swanson on 5/27/24.
//

import SwiftUI

struct TextModalComponent: View {
    
    var modalTitle: String
    var modalHeaderIcon: String
    
    var modalHeading1: String
    var modalText1: String
    
    var modalHeading2: String
    var modalText2: String
    
    var modalHeading3: String
    var modalText3: String
    
    var modalHeading4: String
    var modalText4: String
    
    var modalHeading5: String
    var modalText5: String
    
    var modalHeading6: String
    var modalText6: String
    
    var modalHeading7: String
    var modalText7: String
    
    var modalHeading8: String
    var modalText8: String
    
    var modalHeading9: String
    var modalText9: String
    
    var modalHeading10: String
    var modalText10: String
    
    var modalHeading11: String
    var modalText11: String
    
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color(.lightAccent),
                Color(.whiteBackground),
                Color(.whiteBackground),
                Color(.lightAccent)
                   ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .opacity(0.15)
                   .edgesIgnoringSafeArea(.all)
            
            VStack (alignment: .center) {
                    
                    HStack{
                        Text(modalTitle)
                            .font(.modalHeading)
                            .foregroundStyle(.navyToWhite)
                        Image(systemName: modalHeaderIcon)
                            .font(.modalHeading)
                            .foregroundStyle(.navyToWhite)
                    }
                .padding(.top, 24)
                
                
                ScrollView(showsIndicators: false){
                    
                    VStack (alignment: .leading) {
                        Text(modalHeading1)
                            .font(.smallHeading)
                            .foregroundStyle(.navyToWhite)
                            .padding(.top, 24)
                        Text(modalText1)
                            .font(.regularTextBig)
                            .foregroundStyle(.navyToWhite)
                        
                        Text(modalHeading2)
                            .font(.smallHeading)
                            .foregroundStyle(.navyToWhite)
                            .padding(.top, 24)
                        Text(modalText2)
                            .font(.regularTextBig)
                            .foregroundStyle(.navyToWhite)
                        
                        Text(modalHeading3)
                            .font(.smallHeading)
                            .foregroundStyle(.navyToWhite)
                            .padding(.top, 24)
                        Text(modalText3)
                            .font(.regularTextBig)
                            .foregroundStyle(.navyToWhite)
                        
                        Text(modalHeading4)
                            .font(.smallHeading)
                            .foregroundStyle(.navyToWhite)
                            .padding(.top, 24)
                        Text(modalText4)
                            .font(.regularTextBig)
                            .foregroundStyle(.navyToWhite)
                        
                        Text(modalHeading5)
                            .font(.smallHeading)
                            .foregroundStyle(.navyToWhite)
                            .padding(.top, 24)
                        Text(modalText5)
                            .font(.regularTextBig)
                            .foregroundStyle(.navyToWhite)
                        
                        Text(modalHeading6)
                            .font(.smallHeading)
                            .foregroundStyle(.navyToWhite)
                            .padding(.top, 24)
                        Text(modalText6)
                            .font(.regularTextBig)
                            .foregroundStyle(.navyToWhite)
                        
                        Text(modalHeading7)
                            .font(.smallHeading)
                            .foregroundStyle(.navyToWhite)
                            .padding(.top, 24)
                        Text(modalText7)
                            .font(.regularTextBig)
                            .foregroundStyle(.navyToWhite)
                        
                        Text(modalHeading8)
                            .font(.smallHeading)
                            .foregroundStyle(.navyToWhite)
                            .padding(.top, 24)
                        Text(modalText8)
                            .font(.regularTextBig)
                            .foregroundStyle(.navyToWhite)
                        
                        Text(modalHeading9)
                            .font(.smallHeading)
                            .foregroundStyle(.navyToWhite)
                            .padding(.top, 24)
                        Text(modalText9)
                            .font(.regularTextBig)
                            .foregroundStyle(.navyToWhite)
                        
                        Text(modalHeading10)
                            .font(.smallHeading)
                            .foregroundStyle(.navyToWhite)
                            .padding(.top, 24)
                        Text(modalText10)
                            .font(.regularTextBig)
                            .foregroundStyle(.navyToWhite)
                        
                        Text(modalHeading11)
                            .font(.smallHeading)
                            .foregroundStyle(.navyToWhite)
                            .padding(.top, 24)
                        Text(modalText11)
                            .font(.regularTextBig)
                            .foregroundStyle(.navyToWhite)
                    }
                }
                .padding()
                
                
            }
        }
    }
}

#Preview {
    TextModalComponent(modalTitle: "Modal Title", modalHeaderIcon: "star.fill", modalHeading1: "Here is a title", modalText1: "And here is a bunch of text that will give you some important information.", modalHeading2: "Another title", modalText2: "Look! Even more information to help you feel excited and safe using this app.", modalHeading3: "The final thing", modalText3: "Ok, that's it! You have all you need. And that information should be left aligned.", modalHeading4: "", modalText4: "", modalHeading5: "", modalText5: "",modalHeading6: "",modalText6: "",modalHeading7: "",modalText7: "",modalHeading8: "",modalText8: "",modalHeading9: "",modalText9: "",modalHeading10: "",modalText10: "",modalHeading11: "",modalText11: "")
}
