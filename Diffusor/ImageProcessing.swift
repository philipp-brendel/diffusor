//
//  ImageProcessing.swift
//  Diffusor
//
//  Created by Philipp Brendel on 15.04.25.
//

import AppKit
import CoreImage

func simulateImageProcessing(_ url: URL) -> URL? {
    guard let original = NSImage(contentsOf: url),
          let tiffData = original.tiffRepresentation,
          let ciImage = CIImage(data: tiffData) else {
        return nil
    }

    // Apply a grayscale filter
    let filter = CIFilter(name: "CIPhotoEffectMono")
    filter?.setValue(ciImage, forKey: kCIInputImageKey)

    guard let outputImage = filter?.outputImage else { return nil }

    let rep = NSCIImageRep(ciImage: outputImage)
    let nsImage = NSImage(size: rep.size)
    nsImage.addRepresentation(rep)

    // Save to temporary location
    guard let finalData = nsImage.tiffRepresentation else { return nil }
    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".tiff")

    do {
        try finalData.write(to: tempURL)
        return tempURL
    } catch {
        print("Failed to write image: \(error)")
        return nil
    }
}
