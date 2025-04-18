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
    @State private var selectedFilter: Filter?
    @State private var isProcessing = false
    
    private var filters: [Filter] = standardFilters()
    
    var body: some View {
        NavigationSplitView {
            List(items, selection: $selectedItem) { item in
                NavigationLink(value: item)	 {
                    FilterView(item: item)
                        .frame(height: 64)
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            VStack {
                Picker(selection: $selectedFilter, content: {
                    ForEach(self.filters) { filter in
                        Text(filter.name)
                            .tag(filter)
                    }
                }, label: {
                    Text("Filter")
                })
                .padding(8)
                .disabled(self.isProcessing)
                
                Spacer()
                
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
                
                Spacer()
            }
        }
        .onDrop(of: [UTType.fileURL], isTargeted: $isTargeted) { providers in
            !self.isProcessing && handleDrop(providers: providers)
        }
        .onAppear {
            if !self.filters.isEmpty {
                self.selectedFilter = self.filters[0]
            }
        }
        .onChange(of: selectedFilter) { _, newFilter in
            guard let selectedItem = selectedItem, let filter = newFilter, let originalImage = selectedItem.originalImage else { return }
            
            selectedItem.filteredImage = nil
            self.isProcessing = true
            
            DispatchQueue.global(qos: .background).async {
                let filtered = processImage(originalImage, filter)

                DispatchQueue.main.async {
                    selectedItem.filteredImage = filtered
                    self.isProcessing = false
                }
            }
        }
    }

    private func addItem(from url: URL) {
        guard let filter = self.selectedFilter else { return }
        let newItem = Item(originalImage: url, filteredImage: nil)
        
        withAnimation {
            self.items.append(newItem)
            self.selectedItem = newItem
        }
        
        self.isProcessing = true
        
        DispatchQueue.global(qos: .background).async {
            let filtered = processImage(url, filter)
            		
            DispatchQueue.main.async {
                newItem.filteredImage = filtered
                self.isProcessing = false
            }
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
