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
                
                
                GeometryReader { geometry in
                    
                    ZStack{
                        Color.whiteBackground
                            .ignoresSafeArea()
                    
                    
                    VStack {
                        
                        HStack{
                            //Put menu here
                            Image(systemName: "gearshape.fill")
                                .foregroundStyle(.darkNavy)
                            Spacer()
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        
                        
                        
                        NavigationLink {
                            GameView(entry: getTodayEntry() ?? getPuzzleOfTheDay())
                                .onAppear(perform: checkAndCreateTodayEntry)
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.darkNavy, lineWidth: 12)
                                    .fill(Color.lavender)
                                VStack{
                                    Spacer()
                                    HStack{
                                        Spacer()
                                        Image("inkwell-logo")
                                            .resizable()
                                            .scaledToFit()
                                        Spacer()
                                    }
                                    Spacer()
                                    HStack{
                                        
                                        VStack (alignment: .leading){
                                            Text("GAME")
                                                .foregroundStyle(.darkNavy)
                                                .font(.dateHeader)
                                            
                                            Text("Today's Inkwell")
                                                .foregroundStyle(.darkNavy)
                                                .font(.screenInstruct)
                                            
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                }
                            }
                            .frame(height: geometry.size.height * 0.65)
                            .padding()
                            
                            
                        }
                        NavigationLink {
                            ArchiveView()
                        } label: {
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.lavender, lineWidth: 12)
                                    .fill(Color.whiteBackground)
    
                                    
                                VStack{
                                    Spacer()
                                    HStack{
                                        VStack (alignment: .leading){
                                            Text("ARCHIVES")
                                                .foregroundStyle(.darkNavy)
                                                .font(.dateHeader)
                                            
                                            Text("Your Inkwells")
                                                .foregroundStyle(.darkNavy)
                                                .font(.screenInstruct)
                                            
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                }
                            }
                            .frame(height: geometry.size.height * 0.15)
                            .padding()
                        }
                    }
                    
                }
                
            }
        }
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
        
        // Use a more robust seed generation method
        let seed = dateString.utf8.reduce(0) { ($0 << 8) | Int($1) }
        var generator = SeededRandomNumberGenerator(seed: seed)
        
        let randomCommons = Array(WordList.common.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .common) }
        let randomNouns = Array(WordList.nouns.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .noun) }
        let randomVerbs = Array(WordList.verbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .verb) }
        let randomAdjectives = Array(WordList.adjectives.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adjective) }
        let randomSuffixes = Array(WordList.suffixes.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .suffix)}
        let randomAdverb = Word(text: WordList.adverbs.shuffled(using: &generator).first ?? "", type: .adverb)
        let randomPreposition = Word(text: WordList.prepositions.shuffled(using: &generator).first ?? "", type: .preposition)
        
        let wordList = randomCommons + randomNouns + randomVerbs + randomAdjectives + randomSuffixes + [randomAdverb, randomPreposition]
        
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

// Update the SeededRandomNumberGenerator to use UInt64 for better randomness
struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: Int) {
        self.state = UInt64(seed)
    }

    mutating func next() -> UInt64 {
        state = state &+ 0x9e3779b97f4a7c15
        var z = state
        z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z >> 27)) &* 0x94d049bb133111eb
        return z ^ (z >> 31)
    }
}

#Preview {
    ContentView()
}
