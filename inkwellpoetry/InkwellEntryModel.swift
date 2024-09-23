//
//  InkwellEntryModel.swift
//  inkwellpoetry
//
//  Created by Kristen Swanson on 9/2/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class InkwellEntryModel {
    var date: Date = Date.now
    var wordList: [Word] = [
        Word(text: "", type: .noun),
    ]
    var tileLocations: [TileLocation] = [
        TileLocation(id: UUID(), xPercentage: 0.0, yPercentage: 0.0),
    ]
    var pathData: [PathData] = [
        PathData(points: [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1)], color: Color.red, lineWidth: 2.0),
    ]
    
    var isEdited: Bool = false
    var puzzleType: String = "classic 🎲"
    
    init(date: Date = Date(),
         wordList: [Word] = [
            Word(text: "", type: .noun),
         ],
         tileLocations: [TileLocation] = [
            TileLocation(id: UUID(), xPercentage: 0.0, yPercentage: 0.0),
         ],
         pathData: [PathData] = [
            PathData(points: [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1)], color: Color.red, lineWidth: 2.0),
         ],
         isEdited: Bool = false,
         puzzleType: String = "classic 🎲") {
        self.date = date
        self.wordList = wordList
        self.tileLocations = tileLocations
        self.pathData = pathData
        self.isEdited = isEdited
        self.puzzleType = puzzleType
    }
}

struct Word: Codable {
    var text: String
    var type: WordType
}

enum WordType: String, Codable {
    case noun, verb, adjective, adverb, common, preposition, suffix
}

struct TileLocation: Codable, Identifiable {
    var id: UUID
    var xPercentage: Double?
    var yPercentage: Double?
}

struct PathData: Codable {
    var points: [CGPoint]
    var color: Color
    var lineWidth: CGFloat
    
    enum CodingKeys: String, CodingKey {
        case points, color, lineWidth
    }
    
    init(points: [CGPoint], color: Color, lineWidth: CGFloat) {
        self.points = points
        self.color = color
        self.lineWidth = lineWidth
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        points = try container.decode([CGPoint].self, forKey: .points)
        color = try container.decode(Color.self, forKey: .color)
        lineWidth = try container.decode(CGFloat.self, forKey: .lineWidth)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(points, forKey: .points)
        try container.encode(color, forKey: .color)
        try container.encode(lineWidth, forKey: .lineWidth)
    }
}

extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue, opacity
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = try container.decode(Double.self, forKey: .red)
        let green = try container.decode(Double.self, forKey: .green)
        let blue = try container.decode(Double.self, forKey: .blue)
        let opacity = try container.decode(Double.self, forKey: .opacity)
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var opacity: CGFloat = 0
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &opacity)
        try container.encode(red, forKey: .red)
        try container.encode(green, forKey: .green)
        try container.encode(blue, forKey: .blue)
        try container.encode(opacity, forKey: .opacity)
    }
}
