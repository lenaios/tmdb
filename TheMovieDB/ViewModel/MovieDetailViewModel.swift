//
//  MovieDetailViewModel.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/31.
//

import Foundation

class MovieDetailViewModel {
  let title: String
  let overview: String
  let poster: String
  let rate: String
  let genre: [String]
  var posterImage = Observable<Data?>(value: nil)
  
  @Dependency var posterRepository: DefaultMoviePosterRepository
  
  init(movie: Movie) {
    self.title = movie.title
    self.overview = movie.overview
    self.poster = movie.poster
    self.rate = "\(movie.average)"
    self.genre = movie.genre.map { $0.description }
    setupImage()
  }
  
  private func setupImage() {
    posterRepository.fetch(image: poster) { result in
      switch result {
      case .success(let data):
        self.posterImage.value = data
      case .failure(let error):
        printIfDebug(error.localizedDescription)
      }
    }
  }
}
