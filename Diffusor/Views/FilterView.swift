//
//  FilterView.swift
//  Diffusor
//
//  Created by Philipp Brendel on 13.04.25.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var item: Item
    let aspectRatio: ContentMode
        
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                if let originalImage = item.originalImage {
                    asyncImage(originalImage, width: geometry.size.width / 2, height: geometry.size.height)
                }
                
                if let filteredImage = item.filteredImage {
                    asyncImage(filteredImage, width: geometry.size.width / 2, height: geometry.size.height)
                } else {
                    ProgressView()
                        .frame(width: geometry.size.width / 2, height: geometry.size.height)
                }
            }
        }
    }
    
    fileprivate func asyncImage(_ originalImage: URL, width: CGFloat, height: CGFloat) -> some View {
        return AsyncImage(url: originalImage) { image in
            image
                .resizable()
                .aspectRatio(contentMode: self.aspectRatio)
        } placeholder: {
            ProgressView()
        }
        .frame(width: width, height: height)
    }
}
	
