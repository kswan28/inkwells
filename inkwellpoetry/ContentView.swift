import SwiftUI
import SwiftData
import TelemetryDeck

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Query private var entries: [InkwellEntryModel]
    @Query private var customPuzzleSettings: [CustomPuzzleSettingsModel]
    @State private var contentOpacity: CGFloat = 0.0
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color.whiteBackground
                        .ignoresSafeArea()
                    
                    VStack {
                        HStack {
                            SettingsMenu()
                            Spacer()
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        
                        ScrollView(showsIndicators: false) {
                        
                                VStack {
                                    NavigationLink {
                                        if let todayEntry = getTodayEntry() {
                                            GameViewNoDrawing2(entry: todayEntry, isPuzzleCompleted: todayEntry.isCompleted)
                                        } else {
                                            let newEntry = getPuzzleOfTheDay()
                                            GameViewNoDrawing2(entry: newEntry, isPuzzleCompleted: false)
                                                .onAppear {
                                                    modelContext.insert(newEntry)
                                                    try? modelContext.save()
                                                }
                                        }
                                    } label: {
                                        TodayInkwellButton(geometry: geometry)
                                    }
                                    
                                    NavigationLink {
                                        ArchiveView()
                                    } label: {
                                        ArchivesButton(geometry: geometry, colorScheme: colorScheme)
                                    }
                                }
                                .opacity(contentOpacity)
                            
                        }
                    }
                }
                .onAppear {
                    withAnimation(.easeIn(duration: 0.75)) {
                                          contentOpacity = 1.0
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
            try? modelContext.save()
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
        
        let selectedPuzzleSet = customPuzzleSettings.first?.selectedPuzzleSet ?? "classic 🎲"
        
        // Reset seasonal puzzle types to classic
        let puzzleType = selectedPuzzleSet == "spooky 👻" || selectedPuzzleSet == "merry ☃️" ? "classic 🎲" : selectedPuzzleSet
        
        let seed = dateString.utf8.reduce(0) { ($0 << 8) | Int($1) }
        var generator = SeededRandomNumberGenerator(seed: seed)
        
        var wordList: [Word] = []
        
        switch puzzleType {
        case "spooky 👻":
            wordList += Array(WordList.common.shuffled(using: &generator).prefix(5)).map { Word(text: $0, type: .common) }
            wordList += Array(WordList.spookynouns.shuffled(using: &generator).prefix(4)).map { Word(text: $0, type: .noun) }
            wordList += Array(WordList.spookyverbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .verb) }
            wordList += Array(WordList.spookyadjectives.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adjective) }
            wordList += Array(WordList.suffixes.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .suffix) }
            wordList += Array(WordList.spookyadverbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adverb) }
            wordList += Array(WordList.prepositions.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .preposition) }
        case "swifty 😻":
            wordList += Array(WordList.common.shuffled(using: &generator).prefix(5)).map { Word(text: $0, type: .common) }
            wordList += Array(WordList.swiftynouns.shuffled(using: &generator).prefix(4)).map { Word(text: $0, type: .noun) }
            wordList += Array(WordList.swiftyverbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .verb) }
            wordList += Array(WordList.swiftyadjectives.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adjective) }
            wordList += Array(WordList.suffixes.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .suffix) }
            wordList += Array(WordList.swiftyadverbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adverb) }
            wordList += Array(WordList.prepositions.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .preposition) }
        case "merry ☃️":
            wordList += Array(WordList.common.shuffled(using: &generator).prefix(5)).map { Word(text: $0, type: .common) }
            wordList += Array(WordList.merrynouns.shuffled(using: &generator).prefix(4)).map { Word(text: $0, type: .noun) }
            wordList += Array(WordList.merryverbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .verb) }
            wordList += Array(WordList.merryadjectives.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adjective) }
            wordList += Array(WordList.suffixes.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .suffix) }
            wordList += Array(WordList.merryadverbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adverb) }
            wordList += Array(WordList.prepositions.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .preposition) }
        case "nature 🌳":
            wordList += Array(WordList.common.shuffled(using: &generator).prefix(5)).map { Word(text: $0, type: .common) }
            wordList += Array(WordList.naturenouns.shuffled(using: &generator).prefix(4)).map { Word(text: $0, type: .noun) }
            wordList += Array(WordList.natureverbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .verb) }
            wordList += Array(WordList.natureadjectives.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adjective) }
            wordList += Array(WordList.suffixes.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .suffix) }
            wordList += Array(WordList.natureadverbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adverb) }
            wordList += Array(WordList.prepositions.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .preposition) }
        default:
            wordList += Array(WordList.common.shuffled(using: &generator).prefix(5)).map { Word(text: $0, type: .common) }
            wordList += Array(WordList.nouns.shuffled(using: &generator).prefix(4)).map { Word(text: $0, type: .noun) }
            wordList += Array(WordList.verbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .verb) }
            wordList += Array(WordList.adjectives.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adjective) }
            wordList += Array(WordList.suffixes.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .suffix) }
            wordList += Array(WordList.adverbs.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .adverb) }
            wordList += Array(WordList.prepositions.shuffled(using: &generator).prefix(2)).map { Word(text: $0, type: .preposition) }
        }
        
        let tilesPerRow = 3
        let rows = 5
        let spacing = 0.005
        let tileWidth = (0.5 - (Double(tilesPerRow + 1) * spacing)) / Double(tilesPerRow)
        let tileHeight = tileWidth / 2
        let clusterWidth = Double(tilesPerRow) * tileWidth + (Double(tilesPerRow - 1) * spacing)
        let clusterHeight = Double(rows) * tileHeight + (Double(rows - 1) * spacing)

        let centerX = 0.6
        let centerY = 0.38

        let tileLocations = wordList.enumerated().map { (index, word) in
            let row = index / tilesPerRow
            let column = index % tilesPerRow
            let xPercentage = centerX - (clusterWidth / 2) + (Double(column) * (tileWidth + spacing))
            let yPercentage = centerY - (clusterHeight / 2) + (Double(row) * (tileHeight + spacing))
            return TileLocation(id: UUID(), xPercentage: xPercentage, yPercentage: yPercentage)
        }
        
        let pathData: [PathData] = []
        return InkwellEntryModel(date: Date(), wordList: wordList, tileLocations: tileLocations, pathData: pathData, puzzleType: puzzleType)
    }
}

struct TodayInkwellButton: View {
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.darkNavy, lineWidth: 2)
                .fill(Color.lavender)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image("inkwell-logo")
                        .resizable()
                        .scaledToFit()
                    Spacer()
                }
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
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
        .frame(height: geometry.size.height * 0.75)
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 2)
    }
}

struct ArchivesButton: View {
    let geometry: GeometryProxy
    let colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .stroke(colorScheme == .dark ? Color.darkNavy : Color.lavender, lineWidth: 2)
                .fill(colorScheme == .dark ? Color.allwhite : Color.allwhite)
                
            
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
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
