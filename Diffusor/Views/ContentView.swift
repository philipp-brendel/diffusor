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
    @State private var selectedFilter: Filter?
    
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
        .onAppear {
            if !self.filters.isEmpty {
                self.selectedFilter = self.filters[0]
            }
        }
        .onChange(of: selectedFilter) { _, newFilter in
            guard let selectedItem = selectedItem, let filter = newFilter, let originalImage = selectedItem.originalImage else { return }
            
            selectedItem.filteredImage = nil
            
            DispatchQueue.global(qos: .background).async {
                let filtered = processTheFrigginImage(originalImage, filter)

                DispatchQueue.main.async {
                    selectedItem.filteredImage = filtered
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
        
        DispatchQueue.global(qos: .background).async {
            let filtered = processTheFrigginImage(url, filter)
            		
            DispatchQueue.main.async {
                newItem.filteredImage = filtered
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

func processTheFrigginImage(_ url: URL ,_ filter: Filter) -> URL {
    let original = NSImage(contentsOf: url)!
    let image = imageToGrayscaleFloatBuffer(original)!
    
    filter.apply(to: image)
        
    let filtered = floatBufferToNSImage(buffer: image.buffer, width: Int(image.width), height: Int(image.height))!
    
    let destinationURL = tempUrl()
    try! filtered.tiffRepresentation!.write(to: destinationURL)
    return destinationURL
}

func tempUrl() -> URL {
    let tempDir = FileManager.default.temporaryDirectory
    let tempFileURL = tempDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("tiff")
    return tempFileURL
}

#Preview {
    ContentView()
}
