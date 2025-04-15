//
//  ContentView.swift
//  Diffusor
//
//  Created by Philipp Brendel on 12.04.25.
//

import SwiftUI

struct ContentView: View {
    @State private var items: [Item] = []

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        FilterView(item: item)
                    } label: {
                        Thumbnail(originalImage: item.originalImage, filteredImage: item.filteredImage)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        let originalImage = sampleOriginal
        
        withAnimation {
            let newItem = Item(originalImage: originalImage, filteredImage: nil)
            self.items.append(newItem)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let filteredImage = sampleFiltered
            
            self.items[self.items.count - 1].filteredImage = filteredImage
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            
        }
    }
}

#Preview {
    ContentView()
}
