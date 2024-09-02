//
//  ContentView.swift
//  inkwellpoetry
//
//  Created by Kristen Swanson on 9/2/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [InkwellEntryModel]
    
    var body: some View {
        NavigationStack {
            NavigationLink {
                if let todayEntry = getTodayEntry() {
                    GameView(entry: todayEntry)
                } else {
                    Text("Error loading today's entry")
                }
            } label: {
                Text("Game View")
            }
        }
        .onAppear(perform: checkAndCreateTodayEntry)
    }
    
    private func checkAndCreateTodayEntry() {
        let today = Calendar.current.startOfDay(for: Date())
        if !entries.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            let newEntry = getPuzzleOfTheDay()
            modelContext.insert(newEntry)
        }
    }
    
    private func getTodayEntry() -> InkwellEntryModel? {
        let today = Calendar.current.startOfDay(for: Date())
        return entries.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) })
    }
    
    private func getPuzzleOfTheDay() -> InkwellEntryModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateString = dateFormatter.string(from: Date())
        
        var generator = SeededRandomNumberGenerator(seed: dateString.hash)
        let randomCommons = Array(WordList.common.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .noun) } //figure out how to fix this
        let randomNouns = Array(WordList.nouns.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .noun) }
        let randomVerbs = Array(WordList.verbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .verb) }
        let randomAdjectives = Array(WordList.adjectives.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adjective) }
        let randomAdverb = Word(text: WordList.adverbs.shuffled(using: &generator).first ?? "", type: .adverb)
        let randomPreposition = Word(text: WordList.prepositions.shuffled(using: &generator).first ?? "", type: .adverb) //figure out how to fix this
        
        let wordList = randomCommons + randomNouns + randomVerbs + randomAdjectives + [randomAdverb, randomPreposition]
        
        // Generate tile locations in a cluster at the center of the screen
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let tileWidth: CGFloat = 60 // Adjust as needed
        let tileHeight: CGFloat = 30 // Adjust as needed
        let clusterWidth: CGFloat = tileWidth * 3 + 20 // 3 tiles per row, 10 spacing between tiles
        let clusterHeight: CGFloat = tileHeight * 4 + 30 // 4 rows, 10 spacing between rows

        let centerX = screenWidth / 2
        let centerY = screenHeight / 2

        let tileLocations = wordList.enumerated().map { (index, word) in
            let row = index / 3 // 3 tiles per row
            let column = index % 3
            let x = centerX - clusterWidth / 2 + CGFloat(column) * (tileWidth + 10)
            let y = centerY - clusterHeight / 2 + CGFloat(row) * (tileHeight + 10)
            return TileLocation(id: UUID(), x: x, y: y)
        }
        
        // Initialize empty path data
        let pathData: [PathData] = []
        return InkwellEntryModel(date: Date(), wordList: wordList, tileLocations: tileLocations, pathData: pathData)
    }
}

// Add this struct for seeded random number generation
struct SeededRandomNumberGenerator: RandomNumberGenerator {
    let seed: Int
    var currentValue: Int

    init(seed: Int) {
        self.seed = seed
        self.currentValue = seed
    }

    mutating func next() -> UInt64 {
        currentValue = (currentValue &* 1103515245 &+ 12345) & 0x7FFFFFFF
        return UInt64(currentValue)
    }
}

#Preview {
    ContentView()
}
