//
//  GameView.swift
//  inkwellpoetry
//
//  Created by Kristen Swanson on 9/2/24.
//

import SwiftUI
import SwiftData
import UIKit

struct GameViewNoDrawing2: View {
    @Bindable var entry: InkwellEntryModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @State private var isSharePresented = false
    @State private var screenshotImage: UIImage?
    @State private var formattedDate: String = ""
    @State private var isCapturingScreenshot = false
    @State private var capturedGeometrySize: CGSize?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GameContentView2(
                    entry: entry,
                    formattedDate: $formattedDate,
                    isCapturingScreenshot: $isCapturingScreenshot,  // Remove handleDrawing
                    captureScreenshot: { captureScreenshot(size: capturedGeometrySize ?? geometry.size) }
                )
                
                if isCapturingScreenshot {
                    ProgressView()
                        .scaleEffect(2)
                        .frame(width: 100, height: 100)
                        .background(Color.black.opacity(0.9))
                        .cornerRadius(15)
                }
            }
            .overlay(alignment: .bottom) {
                // Control panel
                HStack {
                    Spacer()
                    
                    Button(action: {
                        capturedGeometrySize = geometry.size
                        captureScreenshot(size: capturedGeometrySize ?? geometry.size)
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .padding()
                            .foregroundStyle(.allwhite)
                    }
                    .disabled(isCapturingScreenshot)
                }
                .padding()
                .cornerRadius(10)
                .padding(.bottom)
            }
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
    
    // Remove drawing-related methods
    // private func handleDrawing(value: DragGesture.Value) { ... }
    // private func finishDrawing() { ... }
    // private func smoothPoint(start: CGPoint, end: CGPoint) -> CGPoint { ... }
}

struct InkspillBackground2: View {
   
    @Environment (\.colorScheme) private var colorScheme
    
    let geometry: GeometryProxy
    let date: Date
    let formattedDateString: String
    
    var body: some View {
        
        ZStack{
            
            Color(.darkNavy)
                .ignoresSafeArea()
            
            VStack {
                Text("Inkwell")
                    .font(.modalHeading)
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
            .padding()
            .background(backgroundColor)
            .foregroundColor(.darkNavy)
            .font(.featuredText)
            .cornerRadius(8)
            .position(
                x: geometry.size.width * (location.xPercentage ?? 0.0) + dragOffset.width,
                y: geometry.size.height * (location.yPercentage ?? 0.0) + dragOffset.height
            )
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
    
    var captureScreenshot: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                InkspillBackground2(geometry: geometry, date: entry.date, formattedDateString: formattedDate)
                
                ForEach(entry.wordList.indices, id: \.self) { index in
                    WordTile2(
                        word: entry.wordList[index],
                        location: $entry.tileLocations[index],
                        type: entry.wordList[index].type,
                        geometry: geometry
                    )
                }
            }
        }
    }
}




