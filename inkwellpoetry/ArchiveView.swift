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
        NavigationStack {
            List(entries.sorted(by: { $0.date > $1.date })) { entry in
                NavigationLink(destination: GameView(entry: entry)) {
                    EntryTile(entry: entry)
                }
            }
            .navigationTitle("Archive")
        }
    }
}

struct EntryTile: View {
    let entry: InkwellEntryModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(formattedDate)
                .font(.headline)
            Text("\(entry.wordList.count) words")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: entry.date)
    }
}

#Preview {
    ArchiveView()
}
