//
//  GameView.swift
//  inkwellpoetry
//
//  Created by Kristen Swanson on 9/2/24.
//

import SwiftUI
import SwiftData

struct GameView: View {
    @Bindable var entry: InkwellEntryModel
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            ForEach(entry.wordList.indices, id: \.self) { index in
                WordTile(word: entry.wordList[index], location: $entry.tileLocations[index], type: entry.wordList[index].type)
                    .onChange(of: entry.tileLocations[index].x) { _, _ in
                        saveChanges()
                    }
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
}

struct WordTile: View {
    let word: Word
    @Binding var location: TileLocation
    @State private var dragOffset: CGSize = .zero
    @GestureState private var isDragging: Bool = false
    var type: WordType
    
    private var backgroundColor: Color {
        switch type {
          case .noun:
              return .blue
          case .verb:
              return .green
          case .adjective:
              return .orange
          case .adverb:
              return .purple
          }
      }
    
    var body: some View {
        Text(word.text)
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(8)
            .position(x: location.x + dragOffset.width, y: location.y + dragOffset.height)
            .gesture(
                DragGesture()
                    .updating($isDragging) { _, state, _ in
                        state = true
                    }
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        location.x += value.translation.width
                        location.y += value.translation.height
                        dragOffset = .zero
                    }
            )
            .animation(.interactiveSpring(), value: isDragging)
    }
    
    
    
    
}

#Preview {
    GameView(entry: InkwellEntryModel(date: Date(), wordList: [Word(text: "example", type: .noun)], tileLocations: [TileLocation(id: UUID(), x: 100, y: 100)], pathData: []))
}
