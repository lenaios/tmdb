//
//  Logger.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/31.
//

import Foundation

func printIfDebug(_ message: String) {
  #if DEBUG
  print(message)
  #endif
}
