//
//  Item.swift
//  Diffusor
//
//  Created by Philipp Brendel on 12.04.25.
//

import Foundation

final class Item: ObservableObject, Identifiable {
    let id = UUID()
    let timestamp = Date()
    @Published var originalImage: URL?
    @Published var filteredImage: URL?
    
    init(originalImage: URL?, filteredImage: URL?) {
        self.originalImage = originalImage
        self.filteredImage = filteredImage
    }
}

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.id == rhs.id
    }
}

extension Item: Hashable {
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
