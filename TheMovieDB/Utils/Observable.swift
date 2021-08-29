//
//  Observable.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/29.
//

import Foundation

final class Observable<Value> {
  
  var value: Value {
    didSet {
      block?(value)
    }
  }
  var block: ((Value) -> Void)?
  
  init(value: Value) {
    self.value = value
  }
  
  func bind(_ block: @escaping (Value) -> Void) {
    self.block = block
    block(value)
  }
}
