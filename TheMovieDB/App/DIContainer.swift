//
//  DIContainer.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/29.
//

import Foundation

@propertyWrapper
struct Dependency<T> {
  var wrappedValue: T {
    DIContainer.shared.resolve()
  }
}

class DIContainer {
  static let shared = DIContainer()
  
  var dependencies: [String: Any] = [:]
  
  func register<T>(_ dependency: T) {
    let key = String(describing: T.self)
    dependencies[key] = dependency
  }
  
  func resolve<T>() -> T {
    let key = String(describing: T.self)
    return dependencies[key] as! T
  }
}
