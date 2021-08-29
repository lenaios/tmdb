//
//  Endpoint.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/28.
//

import Foundation

struct Endpoint {
  private let scheme = "http"
  private let host = "api.themoviedb.org"
  let path: String
  let query: [URLQueryItem]
}

extension Endpoint {
  var url: URL {
    var components = URLComponents()
    components.scheme = scheme
    components.host = host
    components.path = path
    components.queryItems = query
    
    guard let url = components.url else {
      preconditionFailure(
        "Invalid URL components: \(components)"
      )
    }
    return url
  }
}
