//
//  Thumbnail.swift
//  Diffusor
//
//  Created by Philipp Brendel on 15.04.25.
//

import SwiftUI

struct Thumbnail: View {
    let originalImage: URL?
    let filteredImage: URL?
    
    var body: some View {
        HStack {
            if let originalImage {
                AsyncImage(url: originalImage) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 128, height: 64)
                .background(Color.gray)
            }
        }
    }
}

#Preview {
    Thumbnail(originalImage: sampleOriginal, filteredImage: nil)
        .frame(width: 400, height: 200)
}
