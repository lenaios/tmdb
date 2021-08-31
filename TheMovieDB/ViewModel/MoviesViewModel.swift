//
//  MoviesViewModel.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/28.
//

import Foundation

class MoviesViewModel {
  let movieSearchUseCase: MovieSearchUseCase
  
  private var movies: [Movie] = []
  
  var items = Observable<[MovieItemViewModel]>(value: [])
  
  init(movieSearchUseCase: MovieSearchUseCase) {
    self.movieSearchUseCase = movieSearchUseCase
  }
  
  func load(query: String) {
    movieSearchUseCase.search(query: query) { result in
      switch result {
      case .success(let moviesPage):
        self.movies = moviesPage.movies
        self.items.value = moviesPage.movies.map { movie in
          MovieItemViewModel(
            title: movie.title,
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
  
//  func item(for indexPath: Int) -> MovieViewModel {
//    items.value[indexPath]
//  }
  
  func item(for indexPath: Int) -> Movie {
    movies[indexPath]
  }
}
