//
//  InkwellEntryModel.swift
//  inkwellpoetry
//
//  Created by Kristen Swanson on 9/2/24.
//

import Foundation
import SwiftData

@Model
class InkwellEntryModel {
    var date: Date
    var wordList: [Word]
    var tileLocations: [TileLocation]
    var pathData: [PathData]
    var isEdited: Bool
    
    init(date: Date, wordList: [Word], tileLocations: [TileLocation], pathData: [PathData], isEdited: Bool = false) {
        self.date = date
        self.wordList = wordList
        self.tileLocations = tileLocations
        self.pathData = pathData
        self.isEdited = isEdited
    }
}

struct Word: Codable {
    var text: String
    var type: WordType
}

enum WordType: String, Codable {
    case noun, verb, adjective, adverb // Add more types as needed
}

struct TileLocation: Codable {
    var id: UUID
    var x: Double
    var y: Double
}

struct PathData: Codable {
    var points: [CGPoint]
    // Add any other properties needed for path data
}
