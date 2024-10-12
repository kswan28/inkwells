//
//  GameView.swift
//  inkwellpoetry
//
//  Created by Kristen Swanson on 9/2/24.
//

import SwiftUI
import SwiftData
import UIKit
import TelemetryDeck
import MijickPopupView
import Lottie

struct GameViewNoDrawing2: View {
    @Bindable var entry: InkwellEntryModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) var dismiss
    @Query private var customPuzzleSettings: [CustomPuzzleSettingsModel]
    @State private var selectedPuzzleType: String
    @State private var showAlert: Bool = false
    @State private var isSharePresented = false
    @State private var screenshotImage: UIImage?
    @State private var formattedDate: String = ""
    @State private var isCapturingScreenshot = false
    @State private var capturedGeometrySize: CGSize?
    @State private var isPuzzleRefreshing = false
    @State private var animateTiles = false
    @State private var tileScale: CGFloat = 1.0 // New state variable for scale
    @State private var showChangeStylePopup: Bool = false
    @State private var isPuzzleCompleted: Bool
    @State private var showPopperAnimation = false

    init(entry: InkwellEntryModel, isPuzzleCompleted: Bool) {
        self.entry = entry
        _selectedPuzzleType = State(initialValue: entry.puzzleType)
        _isPuzzleCompleted = State(initialValue: entry.isCompleted)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GameContentView2(
                    entry: entry,
                    formattedDate: $formattedDate,
                    isCapturingScreenshot: $isCapturingScreenshot,
                    animateTiles: $animateTiles,
                    tileScale: $tileScale, // Pass the scale to GameContentView2
                    captureScreenshot: { captureScreenshot(size: capturedGeometrySize ?? geometry.size) }
                )
                
                if isCapturingScreenshot {
                    ProgressView()
                        .scaleEffect(2)
                        .frame(width: 100, height: 100)
                        .background(Color.black.opacity(0.9))
                        .cornerRadius(15)
                }
                
                AnimationView(isShowing: $showPopperAnimation, animationName: "popper")
            }
            .overlay(alignment: .bottom) {
                VStack {
                    // Control panel
                    HStack {
                        VStack{
                            Spacer()
                            Text("INKWELL STYLE")
                                .font(.dateHeader)
                                .foregroundStyle(.allwhite)
                                .padding(.bottom, 4)
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 2)
                                    .frame(width:96, height: 120)
                                    .foregroundStyle(.allwhite)
                                VStack{
                                    PuzzleTypeButton(title: "Classic 🎲", type: "classic 🎲", selectedType: $selectedPuzzleType, action: { updatePuzzleType(newType: "classic 🎲") })
                                    PuzzleTypeButton(title: "Spooky 👻", type: "spooky 👻", selectedType: $selectedPuzzleType, action: { updatePuzzleType(newType: "spooky 👻") })
                                    PuzzleTypeButton(title: "Swifty 😻", type: "swifty 😻", selectedType: $selectedPuzzleType, action: { updatePuzzleType(newType: "swifty 😻") })
                                    
                                }
                            }
                        }
                        Spacer()
                        VStack{
                            Spacer()
                            Text(isPuzzleCompleted ? "SHARE" : "I'M DONE")
                                .font(.dateHeader)
                                .foregroundStyle(.allwhite)
                                .padding(.bottom, 4)
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 2)
                                    .frame(width:96, height: 120)
                                    .foregroundStyle(.allwhite)
                                VStack{
                                    Button(action: {
                                        if isPuzzleCompleted {
                                            capturedGeometrySize = geometry.size
                                            captureScreenshot(size: capturedGeometrySize ?? geometry.size)
                                            TelemetryDeck.signal("GameView.shared")
                                        } else {
                                            markPuzzleAsCompleted()
                                        }
                                    }) {
                                        Image(systemName: isPuzzleCompleted ? "square.and.arrow.up" : "hand.thumbsup.fill")
                                            .padding()
                                            .foregroundStyle(.allwhite)
                                            .font(.navigationHeader)
                                    }
                                    .disabled(isCapturingScreenshot)
                                }
                            }
                        }
                    }
                    .padding()
                    .cornerRadius(10)
                    .padding(.bottom)
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    saveChanges()
                    dismiss()
                } label: {
                    HStack{
                        Image(systemName: "arrowshape.backward")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }

            }
        }
        .alert("Change Inkwell style?", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) {
                selectedPuzzleType = entry.puzzleType
            }
            Button("Change", role: .destructive) {
                updateExistingEntry()
                TelemetryDeck.signal("PuzzleStyle.changed")
            }
        } message: {
            Text("This will replace your Inkwell with a new one in the selected style. Are you sure?")
        }
         .sheet(isPresented: $isSharePresented) {
             if let screenshot = screenshotImage {
                 ActivityViewController2(activityItems: [screenshot])
             }
         }
         .onAppear {
             let dateFormatter = DateFormatter()
             dateFormatter.dateStyle = .long
             formattedDate = dateFormatter.string(from: entry.date)
             
             TelemetryDeck.signal("GameView.opened")
         }
     }
     
    private func captureScreenshot(size: CGSize) {
        isCapturingScreenshot = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Define the portion of the view to capture
            let captureView = GameContentView2(
                entry: entry,
                formattedDate: $formattedDate,
                isCapturingScreenshot: $isCapturingScreenshot,
                animateTiles: $animateTiles,
                tileScale: $tileScale,
                captureScreenshot: { self.captureScreenshot(size: size) }
            )
            .frame(width: size.width, height: size.height * 0.7)  // Capture the top 70% which contains inkspill and tiles
            
            let renderer = ImageRenderer(content: captureView)
            renderer.scale = UIScreen.main.scale
            
            // Ensure the proposed size matches the inkspill area
            renderer.proposedSize = ProposedViewSize(CGSize(width: size.width, height: size.height * 0.7))
            
            if let uiImage = renderer.uiImage {
                screenshotImage = uiImage
                isCapturingScreenshot = false
                isSharePresented = true
            } else {
                isCapturingScreenshot = false
            }
        }
    }
    
    private func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving changes: \(error)")
        }
    }
    
    private func updateExistingEntry() {
        isPuzzleRefreshing = true
        let updatedEntry = getPuzzleOfTheDay(puzzleType: selectedPuzzleType)
        
        entry.wordList = updatedEntry.wordList
        entry.tileLocations = updatedEntry.tileLocations
        entry.pathData = updatedEntry.pathData
        entry.puzzleType = updatedEntry.puzzleType
        entry.isCompleted = false
        isPuzzleCompleted = false
        
        saveChanges()
        isPuzzleRefreshing = false
        
        // Trigger the animation with a longer duration
        withAnimation(.easeInOut(duration: 0.8)) { // Increased duration to 0.8 seconds
            animateTiles = true
            tileScale = 1.5 // Scale up
        }
        
        // Reset the animation flag and scale after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeInOut(duration: 0.8)) { // Smoothly scale down
                tileScale = 1.0 // Scale back down
            }
            animateTiles = false
        }
    }
    
    
    //temporary alert until new pop up plug in starts working again
    private func updatePuzzleType(newType:String) {
        if newType != entry.puzzleType {
            selectedPuzzleType = newType
            showAlert = true
        }
    }
    
//    private func updatePuzzleType(newType: String) {
//        if newType != entry.puzzleType {
//            selectedPuzzleType = newType
//            ChangeInkwellStylePopup(
//                onCancel: {
//                    selectedPuzzleType = entry.puzzleType
//                },
//                onChange: {
//                    updateExistingEntry()
//                    TelemetryDeck.signal("PuzzleStyle.changed")
//                }
//            ).showAndStack()
//        }
//    }
    
    private func getPuzzleOfTheDay(puzzleType: String) -> InkwellEntryModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateString = dateFormatter.string(from: Date())
        
        // Use the passed puzzleType instead of fetching from customPuzzleSettings
        // let puzzleType = customPuzzleSettings.first?.selectedPuzzleSet ?? "classic 🎲"
        
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
        let tilesPerRow = 3
        let rows = 5
        let spacing = 0.005 // 2% of screen width/height
        let tileWidth = (0.5 - (Double(tilesPerRow + 1) * spacing)) / Double(tilesPerRow)
        let tileHeight = tileWidth / 2 // Assuming tile height is half of its width
        let clusterWidth = Double(tilesPerRow) * tileWidth + (Double(tilesPerRow - 1) * spacing)
        let clusterHeight = Double(rows) * tileHeight + (Double(rows - 1) * spacing)

        let centerX = 0.6
        let centerY = 0.55

        let tileLocations = wordList.enumerated().map { (index, word) in
            let row = index / tilesPerRow
            let column = index % tilesPerRow
            let xPercentage = centerX - (clusterWidth / 2) + (Double(column) * (tileWidth + spacing))
            let yPercentage = centerY - (clusterHeight / 2) + (Double(row) * (tileHeight + spacing))
            return TileLocation(id: UUID(), xPercentage: xPercentage, yPercentage: yPercentage)
        }
        
        // Initialize empty path data
        let pathData: [PathData] = []
        return InkwellEntryModel(date: Date(), wordList: wordList, tileLocations: tileLocations, pathData: pathData, puzzleType: puzzleType)
    }
    
    
    // Remove drawing-related methods
    // private func handleDrawing(value: DragGesture.Value) { ... }
    // private func finishDrawing() { ... }
    // private func smoothPoint(start: CGPoint, end: CGPoint) -> CGPoint { ... }
    
    private func markPuzzleAsCompleted() {
        isPuzzleCompleted = true
        entry.isCompleted = true
        
        // Delay the save operation slightly to ensure view updates are complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            do {
                try self.modelContext.save()
                print("Puzzle completion status saved successfully")
            } catch {
                print("Failed to save puzzle completion status: \(error)")
            }
        }
        
        // Show the popper animation
        showPopperAnimation = true
        
        // Hide the animation after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showPopperAnimation = false
        }
        
        TelemetryDeck.signal("GameView.completed")
    }
}

struct InkspillBackground2: View {
   
    @Environment(\.colorScheme) private var colorScheme
    
    let geometry: GeometryProxy
    let date: Date
    let formattedDateString: String
    let puzzleType: String
    
    var body: some View {
        
        ZStack{
            
            Color(.darkNavy)
                .ignoresSafeArea()
            
            VStack {
                Text("Inkwell\(puzzleType.suffix(2))")
                    .font(.modalHeading)
                    .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 20 : 8)
                    Text(formattedDateString)
                        .font(.featuredText)
                
                
                Image("background-ink2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 0.8)
                    .padding(.top, 12)
                //.frame(maxHeight: .infinity)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            //.padding(.top, geometry.safeAreaInsets.top + 10)
            .foregroundColor(.allwhite)
        }
    }}

struct WordTile2: View {
    let word: Word
    @Binding var location: TileLocation
    @State private var dragOffset: CGSize = .zero
    @GestureState private var isDragging: Bool = false
    var type: WordType
    let geometry: GeometryProxy
    
    private var backgroundColor: Color {
        switch type {
        case .noun:
            return Color.noun
        case .verb:
            return Color.verb
        case .adjective:
            return Color.adjective
        case .adverb:
            return Color.adverb
        case .common:
            return Color.common
        case .preposition:
            return Color.common
        case .suffix:
            return Color.suffix
        }
    }
    
    var body: some View {
        Text(word.text)
            .padding(UIDevice.current.userInterfaceIdiom == .pad ? 14 : 10)
            .background(backgroundColor)
            .foregroundColor(.allwhite)
            .font(UIDevice.current.userInterfaceIdiom == .pad ? .featuredText : .regularTextBig)
            .cornerRadius(8)
            .position(
                x: geometry.size.width * (location.xPercentage ?? 0.0) + dragOffset.width,
                y: geometry.size.height * (location.yPercentage ?? 0.0) + dragOffset.height
            )
            .scaleEffect(isDragging ? 1.025 : 1.0) // Increased scale on press
            .rotationEffect(.degrees(isDragging ? 1.5 : 0)) // Added rotation on press
            .gesture(
                DragGesture()
                    .updating($isDragging) { _, state, _ in
                        state = true
                    }
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        let newX = geometry.size.width * (location.xPercentage ?? 0.0) + value.translation.width
                        let newY = geometry.size.height * (location.yPercentage ?? 0.0) + value.translation.height
                        location.xPercentage = newX / geometry.size.width
                        location.yPercentage = newY / geometry.size.height
                        dragOffset = .zero
                    }
            )
            .animation(.interactiveSpring(), value: isDragging)
    }
}

struct ActivityViewController2: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct GameContentView2: View {
    @Bindable var entry: InkwellEntryModel
    @Binding var formattedDate: String
    @Binding var isCapturingScreenshot: Bool
    @Binding var animateTiles: Bool
    @Binding var tileScale: CGFloat // New binding for scale

    var captureScreenshot: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                InkspillBackground2(geometry: geometry, date: entry.date, formattedDateString: formattedDate, puzzleType: entry.puzzleType)
                
                ForEach(entry.wordList.indices, id: \.self) { index in
                    WordTile2(
                        word: entry.wordList[index],
                        location: $entry.tileLocations[index],
                        type: entry.wordList[index].type,
                        geometry: geometry
                    )
                    .scaleEffect(animateTiles ? tileScale : 1.0) // Use the tileScale variable
                    .rotation3DEffect(
                        .degrees(animateTiles ? 360 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                }
            }
        }
    }
}

struct PuzzleTypeButton: View {
    let title: String
    let type: String
    @Binding var selectedType: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.regularText)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(selectedType == type ? Color.allwhite : Color.darkNavy)
                .foregroundColor(selectedType == type ? Color.darkNavy : Color.allwhite)
                .cornerRadius(8)
        }
    }
}

struct ChangeInkwellStylePopup: CentrePopup {
    
    @Environment(\.colorScheme) var colorScheme
    
    let onCancel: () -> Void
    let onChange: () -> Void
    
    func createContent() -> some View {
            
            VStack(alignment: .center) {
                
                Image("inkwell-logo")
                    .resizable()
                    .frame(width:120, height: 120)
                    .padding(.top)
                    .padding(.bottom)
                
                Text("Change Inkwell style?")
                    .font(.modalHeading)
                    .foregroundStyle(.darkNavy)
                    .padding(.bottom)
                
                Text("This will update your current Inkwell with a new one in the selected style.\nAre you sure?")
                    .font(.featuredText)
                    .foregroundStyle(.darkNavy)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                HStack(spacing: 20) {
                    Button("Cancel") {
                        onCancel()
                        dismiss()
                    }
                    .padding()
                    .foregroundColor(Color.darkNavy.opacity(0.8))
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            //.stroke(.gray, lineWidth: 6)
                            .fill(.gray)
                            .opacity(0.4)
                            .frame(maxWidth: .infinity)
                        
                    }
                    
                    Button("Change") {
                        onChange()
                        dismiss()
                    }
                    .padding()
                    .foregroundColor(.darkNavy)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.darkNavy, lineWidth: 6)
                            .fill(Color.lavender)
                            .frame(maxWidth: .infinity)
                        
                    }
                    
                }
                .padding(.top)
            }
            .padding()
            .background(.allwhite)
            .cornerRadius(12)
            .shadow(radius: 10)
            
        }
    
    func configurePopup(popup: CentrePopupConfig) -> CentrePopupConfig {
        popup
            .backgroundColour(.black.opacity(0.4))
            .tapOutsideToDismiss(true)
    }
}


