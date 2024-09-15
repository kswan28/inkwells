//
//  ArchiveView.swift
//  inkwellpoetry
//
//  Created by Kristen Swanson on 9/2/24.
//

import SwiftUI
import SwiftData

struct ArchiveView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @Query private var entries: [InkwellEntryModel]
    
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
                
                    ScrollView {
                            LazyVGrid(columns: Array(repeating: GridItem(), count: UIDevice.current.model == "iPad" ? 3 : 2), spacing: 20) {
                                ForEach(entries.sorted(by: { $0.date > $1.date }), id: \.self) { entry in
                                    NavigationLink(destination: GameViewNoDrawing2(entry: entry)) {
                                        EntryTile(entry: entry)
                                    }
                                }
                            }
                        
                    }
                    .padding()
                    
                
                
            }
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
                Text(entry.puzzleType.suffix(1))
                    .font(.dateHeader)
                
            }
            
                ForEach(entry.wordList, id: \.text) { word in
                    Text(word.text)
                        .font(.featuredText)
                        .foregroundColor(colorScheme == .dark ? Color.allwhite : Color.darkNavy)
                        .opacity(0.8)
                }
            
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
