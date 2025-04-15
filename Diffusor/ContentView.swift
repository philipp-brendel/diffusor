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
    @State private var isShowingFileImporter = false
    
    var body: some View {
        NavigationSplitView {
            List(items, selection: $selectedItem) { item in
                NavigationLink(value: item)	 {
                    FilterView(item: item)
                        .frame(height: 64)
                }
//                .onDelete(perform: deleteItems)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        self.isShowingFileImporter = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
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
        .fileImporter(
            isPresented: $isShowingFileImporter,
            allowedContentTypes: [.image],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                addItem(from: url)
            case .failure(let error):
                print("Error importing file: \(error)")
            }
        }
    }

    private func addItem(from url: URL) {
        let newItem = Item(originalImage: url, filteredImage: nil)
        
        withAnimation {
            self.items.append(newItem)
            self.selectedItem = newItem
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            newItem.filteredImage = simulateImageProcessing(url)
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
                            DispatchQueue.main.async {
                                self.addItem(from: url)
                            }
                        } else if let url = item as? URL {
                            DispatchQueue.main.async {
                                self.addItem(from: url)
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
