//
//  FilterView.swift
//  Diffusor
//
//  Created by Philipp Brendel on 13.04.25.
//

import SwiftUI

let sampleOriginal = URL(fileURLWithPath: "/Users/waldrumpus/Downloads/example_large.jpg")

struct FilterView: View {
    let originalImage: URL?
    let filteredImage: URL?
    
    var body: some View {
        HStack {
            if let originalImage {
                AsyncImage(url: originalImage) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
            }
            
            if let filteredImage {
                AsyncImage(url: filteredImage) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    FilterView(originalImage: sampleOriginal, filteredImage: sampleOriginal)
        .frame(width: 400, height: 400)
}
