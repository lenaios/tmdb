//
//  MoviesPage.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/29.
//

import Foundation

struct MoviesPage: Decodable {
  let page: Int
  let total: Int
  let movies: [Movie]
}

extension MoviesPage {
  enum CodingKeys: String, CodingKey {
    case page
    case total = "total_pages"
    case movies = "results"
  }
}
