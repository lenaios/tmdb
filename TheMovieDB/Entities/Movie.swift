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
  let poster: String
  let overview: String
  let release: String
  let average: Float
  let genre: [Genre.ID]
}

extension Movie {
  enum CodingKeys: String, CodingKey {
    case id, title, overview
    case poster = "poster_path"
    case release = "release_date"
    case average = "vote_average"
    case genre = "genre_ids"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.title = try container.decode(String.self, forKey: .title)
    self.poster = try container.decode(String.self, forKey: .poster)
    self.overview = try container.decode(String.self, forKey: .overview)
    self.release = try container.decode(String.self, forKey: .release)
    self.average = try container.decode(Float.self, forKey: .average)
    self.genre = try container.decodeIfPresent([Genre.ID].self, forKey: .genre) ?? []
  }
}
