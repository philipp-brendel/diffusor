//
//  Filter.swift
//  Diffusor
//
//  Created by Philipp Brendel on 18.04.25.
//

import AppKit

protocol FilterImplementation: Hashable {
    var id: String { get }
    var name: String { get }
    func apply(to image: IpImage)
}

func standardFilters() -> [Filter] {
    [
        Filter(filter: GaussianBlur(sigma: 1.0)),
        Filter(filter: CoherenceEnhancingDiffusion(iterationCount: 20)),
        Filter(filter: EdgeEnhancingDiffusion(iterationCount: 20))
    ]
}

struct Filter: Identifiable, Hashable {
    static func == (lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
    
    let filter: any FilterImplementation
    var id: String { filter.id }
    var name: String { filter.name }
    
    func hash(into hasher: inout Hasher) {
        self.filter.hash(into: &hasher)
    }
    
    func apply(to image: IpImage) {
        self.filter.apply(to: image)
    }
}

struct GaussianBlur: FilterImplementation {
    var id: String { "gauss" }
    var name: String { "Gaussian Blur" }
    let sigma: Float
    
    func apply(to image: IpImage) {
        ip_gaussian_smooth(self.sigma, image.width - 2, image.height - 2, image.buffer)
    }
}

struct CoherenceEnhancingDiffusion: FilterImplementation {
    var id: String { "ced" }
    var name: String { "Coherence Enhancing Diffusion" }
    let iterationCount: Int
    
    func apply(to image: IpImage) {
        ip_gaussian_smooth(0.5, image.width - 2, image.height - 2, image.buffer)
        
        for _ in 0...self.iterationCount {
            ip_ced(1.0, 4.0, 0.001, 0.2, image.width - 2, image.height - 2, image.buffer)
        }

    }
}

struct EdgeEnhancingDiffusion: FilterImplementation {
    var id: String { "eed" }
    var name: String { "Edge Enhancing Diffusion" }
    let iterationCount: Int
    
    func apply(to image: IpImage) {
        ip_gaussian_smooth(0.5, image.width - 2, image.height - 2, image.buffer)
        
        for _ in 0...self.iterationCount {
            ip_eed(3.0, 0.2, image.width - 2, image.height - 2, image.buffer)
        }
    }
}

func processImage(_ url: URL ,_ filter: Filter) -> URL {
    let original = NSImage(contentsOf: url)!
    let image = imageToGrayscaleFloatBuffer(original)!
    
    filter.apply(to: image)
        
    let filtered = floatBufferToNSImage(buffer: image.buffer, width: Int(image.width), height: Int(image.height))!
    
    let destinationURL = tempUrl()
    try! filtered.tiffRepresentation!.write(to: destinationURL)
    return destinationURL
}
