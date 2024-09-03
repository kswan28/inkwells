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
    @State private var currentLine: PathData?
    @State private var drawingColor: Color = .black
    @State private var lineWidth: CGFloat = 2
    @StateObject private var undoManager = DrawingUndoManager()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                InkspillBackground(geometry: geometry, date: entry.date)
                
                Canvas { context, size in
                    for path in entry.pathData {
                        var swiftUIPath = Path()
                        swiftUIPath.addLines(path.points)
                        context.stroke(swiftUIPath, with: .color(path.color), lineWidth: path.lineWidth)
                    }
                    if let currentLine = currentLine {
                        var swiftUIPath = Path()
                        swiftUIPath.addLines(currentLine.points)
                        context.stroke(swiftUIPath, with: .color(currentLine.color), lineWidth: currentLine.lineWidth)
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { value in
                            handleDrawing(value: value)
                        }
                        .onEnded { _ in
                            if let line = currentLine {
                                undoManager.registerUndo(currentPaths: entry.pathData) {
                                    entry.pathData.append(line)
                                    self.saveChanges()
                                }
                                entry.pathData.append(line)
                                currentLine = nil
                            }
                        }
                )
                
                ForEach(entry.wordList.indices, id: \.self) { index in
                    WordTile(word: entry.wordList[index], location: $entry.tileLocations[index], type: entry.wordList[index].type)
                        .onChange(of: entry.tileLocations[index].x) { _, _ in
                            saveChanges()
                        }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        ColorPicker("", selection: $drawingColor)
                            .frame(width: 30, height: 30)
                        
                        Slider(value: $lineWidth, in: 1...10)
                            .frame(width: geometry.size.width * 0.5)
                        
                        Text(String(format: "%.1f", lineWidth))
                            .font(.caption)
                        
                        Button(action: {
                            undoLastPath()
                        }) {
                            Image(systemName: "arrow.uturn.backward")
                                .foregroundColor(.primary)
                        }
                        .disabled(!undoManager.canUndo())
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.bottom)
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
            InkspillBackground(geometry: geometry, date: entry.date)
            
            Canvas { context, size in
                for path in entry.pathData {
                    var swiftUIPath = Path()
                    swiftUIPath.addLines(path.points)
                    context.stroke(swiftUIPath, with: .color(path.color), lineWidth: path.lineWidth)
                }
            }
            
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
    
    private func handleDrawing(value: DragGesture.Value) {
        let newPoint = value.location
        if currentLine == nil {
            currentLine = PathData(points: [newPoint], color: drawingColor, lineWidth: lineWidth)
        } else {
            currentLine?.points.append(newPoint)
        }
    }
    
    private func undoLastPath() {
        undoManager.undo { paths in
            entry.pathData = paths
            saveChanges()
        }
    }
}

struct InkspillBackground: View {
    let geometry: GeometryProxy
    let date: Date
    
    var body: some View {
        ZStack {
            Image("inkspill")
                .resizable()
                .frame(height: geometry.size.height * 0.8)
                .frame(maxHeight: .infinity, alignment: .top)
                .frame(width: geometry.size.width * 0.95)
                .clipped()
            
            VStack {
                Spacer()
                VStack {
                    Text("Inkwell")
                        .font(.caption)
                        .fontWeight(.bold)
                    Text(date, style: .date)
                        .font(.caption2)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, geometry.safeAreaInsets.top + 10)
                Spacer()
            }
            .foregroundColor(.white)
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

// Add this extension at the end of the file
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}

// Update this class at the end of the file
class DrawingUndoManager: ObservableObject {
    private var undoStack: [PathData] = []

    func registerUndo(currentPaths: [PathData], redoHandler: @escaping () -> Void) {
        undoStack.append(contentsOf: currentPaths)
        objectWillChange.send()
    }

    func undo(completion: ([PathData]) -> Void) {
        guard !undoStack.isEmpty else { return }
        let lastPaths = undoStack.removeLast()
        completion([lastPaths])
        objectWillChange.send()
    }

    func canUndo() -> Bool {
        return !undoStack.isEmpty
    }

    // canRedo() function removed
}
