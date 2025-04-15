//
//  ContentView.swift
//  Diffusor
//
//  Created by Philipp Brendel on 12.04.25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var isTargeted = false
    @State private var items: [Item] = []
    @State private var selectedItem: Item? = nil

    var body: some View {
        NavigationSplitView {
            List(items, selection: $selectedItem) { item in
                NavigationLink(value: item)	 {
                    Thumbnail(item: item)
                }
//                .onDelete(perform: deleteItems)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
//            .toolbar {
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
        } detail: {
            if let selectedItem {
                FilterView(item: selectedItem)
            } else {
                VStack {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                    Text("Drop an image file here")
                }
            }
        }
        .onDrop(of: [UTType.fileURL], isTargeted: $isTargeted) { providers in
            handleDrop(providers: providers)
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
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
            var found = false
            for provider in providers {
                if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                    provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (item, error) in
                        if let data = item as? Data,
                           let url = NSURL(absoluteURLWithDataRepresentation: data, relativeTo: nil) as URL? {
                            let newItem = Item(originalImage: url, filteredImage: nil)
                            DispatchQueue.main.async {
                                withAnimation {
                                    self.items.append(newItem)
                                    self.selectedItem = newItem
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                newItem.filteredImage = simulateImageProcessing(newItem.originalImage!)
                            }
                        } else if let url = item as? URL {
                            let newItem = Item(originalImage: url, filteredImage: nil)
                            DispatchQueue.main.async {
                                withAnimation {
                                    self.items.append(newItem)
                                    self.selectedItem = newItem
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                newItem.filteredImage = simulateImageProcessing(newItem.originalImage!)
                            }

                        }
                    }
                    found = true
                }
            }
            return found
        }
}

#Preview {
    ContentView()
}
