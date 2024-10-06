//
//  CustomPuzzleSettingsModel.swift
//  inkwellpoetry
//
//  Created by Kristen Swanson on 9/22/24.
//

import Foundation
import SwiftData

@Model
class CustomPuzzleSettingsModel {
    var selectedPuzzleSet: String?
    
    init(selectedPuzzleSet: String = "classic 🎲") {
        self.selectedPuzzleSet = selectedPuzzleSet
    }
}
