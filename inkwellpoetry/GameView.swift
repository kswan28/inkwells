////
////  GameView.swift
////  inkwellpoetry
////
////  Created by Kristen Swanson on 9/2/24.
////
//
//import SwiftUI
//import SwiftData
//import UIKit
//
//struct GameView: View {
//    @Bindable var entry: InkwellEntryModel
//    @Environment(\.modelContext) private var modelContext
//    @Environment(\.colorScheme) private var colorScheme
//    @State private var isSharePresented = false
//    @State private var screenshotImage: UIImage?
//    @State private var currentLine: PathData?
//    @State private var drawingColor: Color = .black
//    @State private var lineWidth: CGFloat = 2
//    @State private var smoothedPath: [CGPoint] = []
//    @State private var lastPoint: CGPoint?
//    @State private var formattedDate: String = ""
//    @State private var isCapturingScreenshot = false
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                GameContentView(
//                    entry: entry,
//                    currentLine: $currentLine,
//                    drawingColor: $drawingColor,
//                    lineWidth: $lineWidth,
//                    smoothedPath: $smoothedPath,
//                    lastPoint: $lastPoint,
//                    formattedDate: $formattedDate,
//                    isCapturingScreenshot: $isCapturingScreenshot, handleDrawing: handleDrawing,
//                    finishDrawing: finishDrawing,
//                    removeAllLines: removeAllLines,
//                    captureScreenshot: { captureScreenshot(size: geometry.size) }
//                )
//                
//                
//                if isCapturingScreenshot {
//                    ProgressView()
//                        .scaleEffect(2)
//                        .frame(width: 100, height: 100)
//                        .background(Color.black.opacity(0.9))
//                        .cornerRadius(15)
//                }
//            }
//            .overlay(alignment: .bottom) {
//                // Control panel
//                HStack {
//                    ColorPicker("", selection: $drawingColor)
//                        .frame(width: 30, height: 30)
//                    
//                    Slider(value: $lineWidth, in: 1...10)
//                        .frame(width: geometry.size.width * 0.2)
//                    
//                    Button(action: {
//                        removeAllLines()
//                    }) {
//                        Image(systemName: "trash")
//                            .foregroundColor(.allwhite)
//                    }
//                    
//                    Spacer()
//                    
//                    Button(action: {
//                        captureScreenshot(size: geometry.size)
//                    }) {
//                        Image(systemName: "square.and.arrow.up")
//                            .padding()
//                            .foregroundStyle(.allwhite)
//                    }
//                    .disabled(isCapturingScreenshot)
//                }
//                .padding()
//                .cornerRadius(10)
//                .padding(.bottom)
//            }
//        }
//         .sheet(isPresented: $isSharePresented) {
//             if let screenshot = screenshotImage {
//                 ActivityViewController(activityItems: [screenshot])
//             }
//         }
//         .onAppear {
//             let dateFormatter = DateFormatter()
//             dateFormatter.dateStyle = .long
//             formattedDate = dateFormatter.string(from: entry.date)
//         }
//     }
//     
//    private func captureScreenshot(size: CGSize) {
//        isCapturingScreenshot = true
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            // Define the portion of the view to capture
//            let captureView = GameContentView(
//                entry: entry,
//                currentLine: $currentLine,
//                drawingColor: $drawingColor,
//                lineWidth: $lineWidth,
//                smoothedPath: $smoothedPath,
//                lastPoint: $lastPoint,
//                formattedDate: $formattedDate,
//                isCapturingScreenshot: $isCapturingScreenshot,
//                handleDrawing: handleDrawing,
//                finishDrawing: finishDrawing,
//                removeAllLines: removeAllLines,
//                captureScreenshot: { self.captureScreenshot(size: size) }
//            )
//            .frame(width: size.width, height: size.height * 0.7)  // Capture the top 70% which contains inkspill and tiles
//            
//            let renderer = ImageRenderer(content: captureView)
//            renderer.scale = UIScreen.main.scale
//            
//            // Ensure the proposed size matches the inkspill area
//            renderer.proposedSize = ProposedViewSize(CGSize(width: size.width, height: size.height * 0.7))
//            
//            if let uiImage = renderer.uiImage {
//                screenshotImage = uiImage
//                isCapturingScreenshot = false
//                isSharePresented = true
//            } else {
//                isCapturingScreenshot = false
//            }
//        }
//    }
//    
//    private func saveChanges() {
//        do {
//            try modelContext.save()
//        } catch {
//            print("Error saving changes: \(error)")
//        }
//    }
//    
//    private func handleDrawing(value: DragGesture.Value) {
//        let newPoint = value.location
//        if currentLine == nil {
//            currentLine = PathData(points: [newPoint], color: drawingColor, lineWidth: lineWidth)
//            smoothedPath = [newPoint]
//            lastPoint = newPoint
//        } else {
//            guard let lastPoint = lastPoint else { return }
//            let smoothedPoint = smoothPoint(start: lastPoint, end: newPoint)
//            smoothedPath.append(smoothedPoint)
//            self.lastPoint = smoothedPoint
//        }
//    }
//    
//    private func finishDrawing() {
//        if var line = currentLine {
//            line.points = smoothedPath
//            entry.pathData.append(line)
//            currentLine = nil
//            smoothedPath = []
//            lastPoint = nil
//            saveChanges()
//        }
//    }
//    
//    private func smoothPoint(start: CGPoint, end: CGPoint) -> CGPoint {
//        let alpha: CGFloat = 0.3
//        return CGPoint(
//            x: start.x + (end.x - start.x) * alpha,
//            y: start.y + (end.y - start.y) * alpha
//        )
//    }
//    
//    // Add this new function to remove all lines
//    private func removeAllLines() {
//        print("Removing all lines. Current pathData count: \(entry.pathData.count)") // Debugging line
//        entry.pathData.removeAll()
//        print("All lines removed. New pathData count: \(entry.pathData.count)") // Debugging line
//        saveChanges()
//    }
//}
//
//struct InkspillBackground: View {
//    let geometry: GeometryProxy
//    let date: Date
//    let formattedDateString: String
//    @Environment(\.colorScheme) private var colorScheme
//    
//    var body: some View {
//        
//        ZStack{
//            
//            Color(.darkNavy)
//                .ignoresSafeArea()
//            
//            VStack {
//                Text("Inkwell")
//                    .font(.modalHeading)
//                Text(formattedDateString)
//                    .font(.featuredText)
//                
//                Image("background-ink2")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: geometry.size.width * 0.8)
//                    .padding(.top, 12)
//                //.frame(maxHeight: .infinity)
//                
//                Spacer()
//            }
//            .frame(maxWidth: .infinity)
//            //.padding(.top, geometry.safeAreaInsets.top + 10)
//            .foregroundColor(colorScheme == .dark ? Color.allwhite : Color.darkNavy)
//        }
//    }}
//
//struct WordTile: View {
//    let word: Word
//    @Binding var location: TileLocation
//    @State private var dragOffset: CGSize = .zero
//    @GestureState private var isDragging: Bool = false
//    var type: WordType
//    
//    private var backgroundColor: Color {
//        switch type {
//          case .noun:
//            return Color.noun
//          case .verb:
//            return Color.verb
//          case .adjective:
//            return Color.adjective
//          case .adverb:
//            return Color.adverb
//        case .common:
//            return Color.common
//        case .preposition:
//            return Color.common
//        case .suffix:
//            return Color.suffix
//          }
//      }
//    
//    var body: some View {
//        Text(word.text)
//            .padding()
//            .background(backgroundColor)
//            .foregroundColor(.darkNavy)
//            .font(.featuredText)
//            .cornerRadius(8)
//            .position(x: location.x + dragOffset.width, y: location.y + dragOffset.height)
//            .gesture(
//                DragGesture()
//                    .updating($isDragging) { _, state, _ in
//                        state = true
//                    }
//                    .onChanged { value in
//                        dragOffset = value.translation
//                    }
//                    .onEnded { value in
//                        location.x += value.translation.width
//                        location.y += value.translation.height
//                        dragOffset = .zero
//                    }
//            )
//            .animation(.interactiveSpring(), value: isDragging)
//    }
//}
//
//struct ActivityViewController: UIViewControllerRepresentable {
//    let activityItems: [Any]
//    
//    func makeUIViewController(context: Context) -> UIActivityViewController {
//        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
//    }
//    
//    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
//}
//
//struct GameContentView: View {
//    @Bindable var entry: InkwellEntryModel
//    @Binding var currentLine: PathData?
//    @Binding var drawingColor: Color
//    @Binding var lineWidth: CGFloat
//    @Binding var smoothedPath: [CGPoint]
//    @Binding var lastPoint: CGPoint?
//    @Binding var formattedDate: String
//    @Binding var isCapturingScreenshot: Bool
//    
//    var handleDrawing: (DragGesture.Value) -> Void
//    var finishDrawing: () -> Void
//    var removeAllLines: () -> Void
//    var captureScreenshot: () -> Void
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                InkspillBackground(geometry: geometry, date: entry.date, formattedDateString: formattedDate)
//                
//                Canvas { context, size in
//                    for path in entry.pathData {
//                        var swiftUIPath = Path()
//                        swiftUIPath.addLines(path.points)
//                        context.stroke(swiftUIPath, with: .color(path.color), lineWidth: path.lineWidth)
//                    }
//                    if let currentLine = currentLine {
//                        var swiftUIPath = Path()
//                        swiftUIPath.addLines(smoothedPath)
//                        context.stroke(swiftUIPath, with: .color(currentLine.color), lineWidth: currentLine.lineWidth)
//                    }
//                }
//                .gesture(
//                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
//                        .onChanged { value in
//                            handleDrawing(value)
//                        }
//                        .onEnded { _ in
//                            finishDrawing()
//                        }
//                )
//                
//                ForEach(entry.wordList.indices, id: \.self) { index in
//                    WordTile(word: entry.wordList[index], location: $entry.tileLocations[index], type: entry.wordList[index].type)
//                }
//            }
//        }
//    }
//}
//
//
//// Add this extension at the end of the file
//extension CGPoint {
//    func distance(to point: CGPoint) -> CGFloat {
//        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
//    }
//}
