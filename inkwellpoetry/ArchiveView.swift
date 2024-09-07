//
//  ArchiveView.swift
//  inkwellpoetry
//
//  Created by Kristen Swanson on 9/2/24.
//

import SwiftUI
import SwiftData

struct ArchiveView: View {
    @Query private var entries: [InkwellEntryModel]
    
    var body: some View {
        
        ZStack{
            Color.darkNavy
                .ignoresSafeArea()
            NavigationStack {
                
                VStack{
                    Text("Your Inkwells")
                        .font(.modalHeading)
                        .foregroundStyle(.whiteBackground)
                }
                .padding()
                
                    ScrollView {
                            LazyVGrid(columns: Array(repeating: GridItem(), count: UIDevice.current.model == "iPad" ? 3 : 2), spacing: 20) {
                                ForEach(entries.sorted(by: { $0.date > $1.date }), id: \.self) { entry in
                                    NavigationLink(destination: GameView(entry: entry)) {
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(formattedDate)
                .font(.dateHeader)
                .foregroundStyle(.darkNavy)
            
                ForEach(entry.wordList, id: \.text) { word in
                    Text(word.text)
                        .font(.featuredText)
                        .foregroundColor(.darkNavy)
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
