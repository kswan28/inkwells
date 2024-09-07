//
//  FontHelper.swift
//  you-did-something-great-today
//
//  Created by Kristen Swanson on 5/4/24.
//

import Foundation
import SwiftUI

extension Font {
    
    
    static var screenHeading = Font.custom("Arvo-Bold", size: 32)
    static var modalHeading = Font.custom("Arvo-Bold", size: 24)
    static var calltoAction = Font.custom("Arvo-Regular", size: 24)
    static var smallHeading = Font.custom ("Arvo-Bold", size: 16)
    static var dateHeader = Font.custom ("Arvo-Bold", size: 10)
    
    static var screenInstruct = Font.custom("Lato-Regular", size: 18)
    static var featuredText = Font.custom("Lato-Regular", size: 16)
    static var regularTextBig = Font.custom ("Lato-Regular", size: 12)
    static var regularText = Font.custom("Lato-Regular", size: 10)
}


//Font names

//Inter
//-- Inter-Regular
//-- Inter-ExtraLight
//-- Inter-Light
//-- Inter-Medium
//-- Inter-SemiBold
//-- Inter-Bold
//-- Inter-ExtraBold
//-- Inter-Black

//Function to print out font names in the console if needed

/*
init() {
    for familyName in UIFont.familyNames {
        print(familyName)
        
        for fontName in UIFont.fontNames(forFamilyName: familyName) {
            
            print("-- \(fontName)")
        }
    }
}
*/

