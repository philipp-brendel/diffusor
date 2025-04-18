//
//  ImageConversion.swift
//  Diffusor
//
//  Created by Philipp Brendel on 18.04.25.
//
import AppKit

func imageToGrayscaleFloatBuffer(_ image: NSImage) -> (UnsafeMutablePointer<UnsafeMutablePointer<Float>?>, Int32, Int32)? {
    guard let tiffData = image.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiffData) else {
        return nil
    }

    let width = Int32(bitmap.pixelsWide)
    let height = Int32(bitmap.pixelsHigh)
    
    // Create float** buffer: allocate array of row pointers
    let buffer = UnsafeMutablePointer<UnsafeMutablePointer<Float>?>.allocate(capacity: Int(width))
    
    for x in 0..<Int(width) {
        let column = UnsafeMutablePointer<Float>.allocate(capacity: Int(height))
        for y in 0..<Int(height) {
            if let color = bitmap.colorAt(x: x, y: y)?.usingColorSpace(.deviceRGB) {
                // Compute luminance manually
                let r = Float(color.redComponent)
                let g = Float(color.greenComponent)
                let b = Float(color.blueComponent)
                let gray = 255 * (0.299 * r + 0.587 * g + 0.114 * b)
                column[y] = gray
            } else {
                column[y] = 0.0
            }
        }
        buffer[x] = column
    }

    return (buffer, width, height)
}

func floatBufferToNSImage(buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>, width: Int, height: Int) -> NSImage? {
    let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil,
                                  pixelsWide: width,
                                  pixelsHigh: height,
                                  bitsPerSample: 8,
                                  samplesPerPixel: 1,
                                  hasAlpha: false,
                                  isPlanar: false,
                                  colorSpaceName: .deviceWhite,
                                  bytesPerRow: width,
                                  bitsPerPixel: 8)
    
    guard let data = bitmap?.bitmapData else { return nil }

    for x in 0..<width {
        for y in 0..<height {
            let value = UInt8(clamping: Int(buffer[x]![y]))
            data[y * width + x] = value
        }
    }

    let image = NSImage(size: NSSize(width: width, height: height))
    image.addRepresentation(bitmap!)
    return image
}
