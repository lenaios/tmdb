//
//  MoviesViewModel.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/28.
//

import Foundation

class MoviesViewModel {
  let movieSearchUseCase: MovieSearchUseCase
  
  var items = Observable<[MovieViewModel]>(value: [])
  
  init(movieSearchUseCase: MovieSearchUseCase) {
    self.movieSearchUseCase = movieSearchUseCase
  }
  
  func load(query: String) {
    movieSearchUseCase.search(query: query) { result in
      switch result {
      case .success(let moviesPage):
        self.items.value = moviesPage.movies.map { movie in
          MovieViewModel(
            title: movie.title,
            overview: movie.overview,
            poster: movie.poster,
            rate: "\(movie.average)",
            genre: movie.genre.compactMap({ id in
              id.description
            }))
        }
      case .failure(let error):
        fatalError(error.localizedDescription)
      }
    }
  }
}
