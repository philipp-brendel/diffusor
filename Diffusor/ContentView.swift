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
                        FilterView(originalImage: item.originalImage, filteredImage: item.filteredImage)
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
        let originalImage = URL(fileURLWithPath: "/Users/waldrumpus/Downloads/example_large.jpg")
        
        withAnimation {
            let newItem = Item(originalImage: originalImage, filteredImage: nil)
            self.items.append(newItem)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let filteredImage = URL(fileURLWithPath: "/Users/waldrumpus/Downloads/example_small.png")
            
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
