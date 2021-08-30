//
//  PosterImageCache.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/31.
//

import Foundation

protocol ImageCache {
  func exist(_ image: String) -> Bool
  func image(_ image: String) -> Data?
  func save(data: Data, atPath name: String)
}

class PosterImageCache: ImageCache {
  let fileManager = FileManager.default
  
  var cache: URL {
    fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("Cache")
  }
  
  func exist(_ image: String) -> Bool {
    let fullPath = cache.appendingPathComponent(image)
    return fileManager.fileExists(atPath: fullPath.path)
  }
  
  func image(_ image: String) -> Data? {
    let fullPath = cache.appendingPathComponent(image)
    return fileManager.contents(atPath: fullPath.path)
  }
  
  func save(data: Data, atPath name: String) {
    let path = cache.appendingPathComponent(name)
    do {
      try data.write(to: path)
    } catch {
      #if DEBUG
      print("Fail to save")
      #endif
    }
  }
}
