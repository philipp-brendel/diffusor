//
//  Thumbnail.swift
//  Diffusor
//
//  Created by Philipp Brendel on 15.04.25.
//

import SwiftUI

struct Thumbnail: View {
    @ObservedObject var item: Item
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                if let originalImage = item.originalImage {
                    AsyncImage(url: originalImage) { image in
                        image.resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: geometry.size.width / 2)
                }
                
                if let filteredImage = item.filteredImage {
                    AsyncImage(url: filteredImage) { image in
                        image.resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: geometry.size.width / 2)
                }
            }
        }
        .frame(height: 64)
    }
}
