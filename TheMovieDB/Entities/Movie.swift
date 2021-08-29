//
//  Movie.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/28.
//

import Foundation

struct Movie: Decodable {
  let id: Int
  let title: String
  let posterPath: String
  let overview: String
}

struct MoviesPage: Decodable {
  let page: Int
  let totalPages: Int
  let results: [Movie]
}
