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
