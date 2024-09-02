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
    @State private var isSharePresented = false
    @State private var screenshotImage: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                InkspillBackground(geometry: geometry)
                
                ForEach(entry.wordList.indices, id: \.self) { index in
                    WordTile(word: entry.wordList[index], location: $entry.tileLocations[index], type: entry.wordList[index].type)
                        .onChange(of: entry.tileLocations[index].x) { _, _ in
                            saveChanges()
                        }
                }
            }
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    Task {
                        await captureScreenshot(of: geometry)
                        isSharePresented = true
                    }
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .padding()
                }
            }
            .sheet(isPresented: $isSharePresented) {
                if let screenshot = screenshotImage {
                    ActivityViewController(activityItems: [screenshot])
                }
            }
        }
    }
    
    @MainActor
    private func captureScreenshot(of geometry: GeometryProxy) async {
        let renderer = ImageRenderer(content: ZStack {
            InkspillBackground(geometry: geometry)
            ForEach(entry.wordList.indices, id: \.self) { index in
                WordTile(word: entry.wordList[index], location: .constant(entry.tileLocations[index]), type: entry.wordList[index].type)
            }
        })
        renderer.scale = UIScreen.main.scale
        if let uiImage = renderer.uiImage {
            screenshotImage = uiImage
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

struct InkspillBackground: View {
    let geometry: GeometryProxy
    
    var body: some View {
        Image("inkspill")
            .resizable()
            .frame(height: geometry.size.height * 0.8)
            .frame(maxHeight: .infinity, alignment: .top)
            .frame(width: geometry.size.width * 0.95)
            .clipped()
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

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    GameView(entry: InkwellEntryModel(date: Date(), wordList: [Word(text: "example", type: .noun)], tileLocations: [TileLocation(id: UUID(), x: 100, y: 100)], pathData: []))
}
