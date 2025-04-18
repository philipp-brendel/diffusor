//
//  FileSystem.swift
//  Diffusor
//
//  Created by Philipp Brendel on 18.04.25.
//

import Foundation

func tempUrl() -> URL {
    let tempDir = FileManager.default.temporaryDirectory
    let tempFileURL = tempDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("tiff")
    return tempFileURL
}
