//
//  FilterView.swift
//  Diffusor
//
//  Created by Philipp Brendel on 13.04.25.
//

import SwiftUI

let sampleOriginal = URL(fileURLWithPath: "/Users/waldrumpus/Downloads/example_large.jpg")
let sampleFiltered = URL(fileURLWithPath: "/Users/waldrumpus/Downloads/example_small.png")

struct FilterView: View {
    @ObservedObject var item: Item
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                if let originalImage = item.originalImage {
                    AsyncImage(url: originalImage) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: geometry.size.width / 2, height: geometry.size.height)
                }
                
                if let filteredImage = item.filteredImage {
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
}
	
