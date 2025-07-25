//
//  ArchiveView.swift
//  inkwellpoetry
//
//  Created by Kristen Swanson on 9/2/24.
//

import SwiftUI
import SwiftData
import TelemetryDeck

struct ArchiveView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [InkwellEntryModel]
    @State private var entryToDelete: InkwellEntryModel?
    
    var body: some View {
        
        ZStack{
            Color.darkNavy
                .ignoresSafeArea()
            NavigationStack {
                
                VStack{
                    Text("Your Inkwells")
                        .font(.modalHeading)
                        .foregroundColor(.allwhite)
                }
                .padding()
                
                
                
                if entries.isEmpty {
                        VStack (alignment: .center){
                            Text("👋")
                                .font(.screenHeading)
                            Text("No Inkwells yet!")
                                .font(.smallHeading)
                                .foregroundStyle(.allwhite)
                            Text("Go back and click on 'Today's Inkwell'\nto complete your first Inkwell.")
                                .font(.regularTextBig)
                                .foregroundStyle(.allwhite)
                                .multilineTextAlignment(.center)
                    }
                    .padding()
                }
                
                
                
                ScrollView {
                                    LazyVGrid(columns: Array(repeating: GridItem(), count: UIDevice.current.model == "iPad" ? 3 : 2), spacing: 20) {
                                        ForEach(entries.sorted(by: { $0.date > $1.date }), id: \.self) { entry in
                                            NavigationLink(destination: GameViewNoDrawing2(entry: entry, isPuzzleCompleted: entry.isCompleted)) {
                                                EntryTile(entry: entry)
                                                    .contextMenu {
                                                        Button(role: .destructive) {
                                                            entryToDelete = entry
                                                        } label: {
                                                            Label("Delete", systemImage: "trash")
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                
                if #available (iOS 26.0, *) {
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrowshape.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(10)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.darkNavy)
                    }
                    .buttonStyle(.plain)
                }
                
                else {
                                    Button {
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
        }
        .onAppear{
            TelemetryDeck.signal("ArchiveView.opened")
        }
        .alert("Delete this Inkwell?", isPresented: Binding<Bool>(
                            get: { entryToDelete != nil },
                            set: { if !$0 { entryToDelete = nil } }
                        )) {
                            Button("Cancel", role: .cancel) { }
                            Button("Delete", role: .destructive) {
                                if let entryToDelete = entryToDelete {
                                    modelContext.delete(entryToDelete)
                                    try? modelContext.save()
                                }
                                entryToDelete = nil
                            }
                        } message: {
                            Text("This action cannot be undone.")
                        }
                    }
                }

struct EntryTile: View {
    let entry: InkwellEntryModel
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack{
                Text(formattedDate)
                    .font(.dateHeader)
                    .foregroundColor(colorScheme == .dark ? Color.allwhite : Color.darkNavy)
                
                Button {
                    //write the favorite status
                    entry.isFavorite.toggle()
                } label: {
                    Image(systemName: entry.isFavorite == true ? "heart.fill" : "heart")
                        .font(.regularTextBig)
                        .foregroundColor(colorScheme == .dark ? Color.allwhite : Color.darkNavy)
                        
                }
                .symbolEffect(.bounce.up, value: entry.isFavorite)
                
            }
                ForEach(entry.wordList, id: \.text) { word in
                    Text(word.text)
                        .font(.featuredText)
                        .foregroundColor(colorScheme == .dark ? Color.allwhite : Color.darkNavy)
                        .opacity(0.8)
                }
            Text("Puzzle style: \(entry.puzzleType.suffix(1))")
                .font(.dateHeader)
                .foregroundColor(colorScheme == .dark ? Color.allwhite : Color.darkNavy)
                .opacity(0.8)
            
        }
        .padding()
        .background(Color.whiteBackground.opacity(0.7))
        .cornerRadius(10)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: entry.date)
    }
}

#Preview {
    ArchiveView()
}
