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
    @Environment(\.colorScheme) private var colorScheme
    @Query private var entries: [InkwellEntryModel]
    
    @AppStorage("selectedPuzzleType") private var selectedPuzzleType: String = "classic 🎲" // Default puzzle type
       @State private var showAlert: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            
            GeometryReader { geometry in
                
                ZStack{
                    Color.whiteBackground
                        .ignoresSafeArea()
                    
                    
                    VStack {
                        
                        HStack{
                            //Put menu here
                            SettingsMenu()
                            Spacer()
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        
//                        HStack{
//                            Text("Let's write!")
//                                .foregroundStyle(.darkNavy)
//                                .font(.screenHeading)
//                            Spacer()
//                        }
//                        .padding(.top)
//                        .padding(.horizontal)
                        
                        // Puzzle Type Picker
                                              Picker("Select Puzzle Type", selection: $selectedPuzzleType) {
                                                  Text("Classic 🎲").tag("classic 🎲")
                                                  Text("Spooky 👻").tag("spooky 👻")
                                                  Text("Swifty 😻").tag("swifty 😻")
                                                  // Add more puzzle types as needed
                                              }
                                              .pickerStyle(SegmentedPickerStyle())
                                              .padding(4)
                                              .frame(maxWidth: geometry.size.width * 0.8)
                                              .onChange(of: selectedPuzzleType) { oldValue, newValue in
                                                  if let todayEntry = getTodayEntry(), todayEntry.puzzleType != newValue {
                                                      showAlert = true
                                                  }
                                              }
                                              
                                              // Alert for overriding the current puzzle
                                              .alert("Overwrite today's puzzle?", isPresented: $showAlert) {
                                                  Button("Cancel", role: .cancel) {
                                                      if let currentEntry = getTodayEntry() {
                                                                            selectedPuzzleType = currentEntry.puzzleType
                                                                        }
                                                  }
                                                  Button("Overwrite", role: .destructive) {
                                                      overrideCurrentPuzzle()
                                                  }
                                              }
                        
                        ScrollView(showsIndicators: false) {
                            NavigationLink {
                                GameViewNoDrawing2(entry: getTodayEntry() ?? getPuzzleOfTheDay())
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
                                .padding(.horizontal)
                                .padding(.top, 12)
                                .padding(.bottom, 2)
                                
                                
                            }
                            NavigationLink {
                                ArchiveView()
                            } label: {
                                ZStack{
                                    
                                    if colorScheme == .dark {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(colorScheme == .dark ? Color.darkNavy : Color.lavender, lineWidth: 12)
                                            .fill(colorScheme == .dark ? Color.allwhite : Color.whiteBackground.opacity(0.4))
                                    }
                                    
                                    else {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.lavender, lineWidth: 12)
                                            .fill(Color.whiteBackground)
                                    }
                                    
                                    
                                  
                                    
                                    
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
                                .frame(height: geometry.size.height * 0.125)
                                .padding()
                            }
                        }
                    }
                }
                
            }
        }
        .onAppear {
            print(selectedPuzzleType)
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
    
    private func overrideCurrentPuzzle() {
        if let todayEntry = getTodayEntry() {
            modelContext.delete(todayEntry)
        }
        let newPuzzle = getPuzzleOfTheDay()
        modelContext.insert(newPuzzle)
        try? modelContext.save()
    }
    
    private func getPuzzleOfTheDay() -> InkwellEntryModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateString = dateFormatter.string(from: Date())
        
        let puzzleType = selectedPuzzleType
        
        // Use a more robust seed generation method
        let seed = dateString.utf8.reduce(0) { ($0 << 8) | Int($1) }
        var generator = SeededRandomNumberGenerator(seed: seed)
        
        // Get the puzzle type from the current date or logic
          var wordList: [Word] = []
        
        // Conditional logic based on puzzleType
        switch puzzleType {
        case "spooky 👻":
            wordList += Array(WordList.common.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .common) }
            wordList += Array(WordList.spookynouns.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .noun) }
            wordList += Array(WordList.spookyverbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .verb) }
            wordList += Array(WordList.spookyadjectives.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adjective) }
            wordList += Array(WordList.suffixes.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .suffix) }
            wordList += Array(WordList.spookyadverbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adverb) }
            wordList += Array(WordList.prepositions.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .preposition) }
        case "swifty 😻":
            wordList += Array(WordList.common.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .common) }
            wordList += Array(WordList.swiftynouns.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .noun) }
            wordList += Array(WordList.swiftyverbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .verb) }
            wordList += Array(WordList.swiftyadjectives.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adjective) }
            wordList += Array(WordList.suffixes.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .suffix) }
            wordList += Array(WordList.swiftyadverbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adverb) }
            wordList += Array(WordList.prepositions.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .preposition) }
        default:
            wordList += Array(WordList.common.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .common) }
            wordList += Array(WordList.nouns.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .noun) }
            wordList += Array(WordList.verbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .verb) }
            wordList += Array(WordList.adjectives.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adjective) }
            wordList += Array(WordList.suffixes.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .suffix) }
            wordList += Array(WordList.adverbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adverb) }
            wordList += Array(WordList.prepositions.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .preposition) }
        }
        
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
        return InkwellEntryModel(date: Date(), wordList: wordList, tileLocations: tileLocations, pathData: pathData, puzzleType: puzzleType)
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
