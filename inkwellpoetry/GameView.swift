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
    @State private var smoothedPath: [CGPoint] = []
    @State private var lastPoint: CGPoint?
    @State private var formattedDate: String = ""

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                InkspillBackground(geometry: geometry, date: entry.date, formattedDateString: formattedDate)
                
                Canvas { context, size in
                    for path in entry.pathData {
                        var swiftUIPath = Path()
                        swiftUIPath.addLines(path.points)
                        context.stroke(swiftUIPath, with: .color(path.color), lineWidth: path.lineWidth)
                    }
                    if let currentLine = currentLine {
                        var swiftUIPath = Path()
                        swiftUIPath.addLines(smoothedPath)
                        context.stroke(swiftUIPath, with: .color(currentLine.color), lineWidth: currentLine.lineWidth)
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { value in
                            handleDrawing(value: value)
                        }
                        .onEnded { _ in
                            finishDrawing()
                        }
                )
                
                ForEach(entry.wordList.indices, id: \.self) { index in
                    WordTile(word: entry.wordList[index], location: $entry.tileLocations[index], type: entry.wordList[index].type)
                        .onChange(of: entry.tileLocations[index].x) { _, _ in
                            saveChanges()
                        }
                }
            }
            .overlay(alignment: .bottom) {
                // Control panel
                HStack {
                    ColorPicker("", selection: $drawingColor)
                        .frame(width: 30, height: 30)
                    
                    Slider(value: $lineWidth, in: 1...10)
                        .frame(width: geometry.size.width * 0.2)
                    
                    Button(action: {
                        removeAllLines()
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.whiteBackground)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await captureScreenshot(of: geometry)
                            isSharePresented = true
                        }
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .padding()
                            .foregroundStyle(.whiteBackground)
                    }
                }
                .padding()
                //.background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .padding(.bottom)
            }
            .sheet(isPresented: $isSharePresented) {
                if let screenshot = screenshotImage {
                    ActivityViewController(activityItems: [screenshot])
                }
            }
        }
        .onAppear {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            formattedDate = dateFormatter.string(from: entry.date)
        }
    }
    
    @MainActor
    private func captureScreenshot(of geometry: GeometryProxy) async {
        // Format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        formattedDate = dateFormatter.string(from: entry.date)
        
        let renderer = ImageRenderer(content: ZStack {
            InkspillBackground(geometry: geometry, date: entry.date, formattedDateString: formattedDate)
            
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
            smoothedPath = [newPoint]
            lastPoint = newPoint
        } else {
            guard let lastPoint = lastPoint else { return }
            let smoothedPoint = smoothPoint(start: lastPoint, end: newPoint)
            smoothedPath.append(smoothedPoint)
            self.lastPoint = smoothedPoint
        }
    }
    
    private func finishDrawing() {
        if var line = currentLine {
            line.points = smoothedPath
            entry.pathData.append(line)
            currentLine = nil
            smoothedPath = []
            lastPoint = nil
            saveChanges()
        }
    }
    
    private func smoothPoint(start: CGPoint, end: CGPoint) -> CGPoint {
        let alpha: CGFloat = 0.3
        return CGPoint(
            x: start.x + (end.x - start.x) * alpha,
            y: start.y + (end.y - start.y) * alpha
        )
    }
    
    // Add this new function to remove all lines
    private func removeAllLines() {
        print("Removing all lines. Current pathData count: \(entry.pathData.count)") // Debugging line
        entry.pathData.removeAll()
        print("All lines removed. New pathData count: \(entry.pathData.count)") // Debugging line
        saveChanges()
    }
}

struct InkspillBackground: View {
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
            .foregroundColor(.whiteBackground)
        }
    }}

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
        case .common:
            return .red
        case .preposition:
            return .gray
        case .suffix:
            return .pink
          }
      }
    
    var body: some View {
        Text(word.text)
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .font(.featuredText)
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
