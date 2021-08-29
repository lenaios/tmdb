//
//  MovieSearchUseCase.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/28.
//

import Foundation

protocol MovieSearchUseCase {
  func search(query: String, completion: @escaping (Result<MoviesPage, Error>) -> Void)
}

final class DefaultMovieSearchUseCase: MovieSearchUseCase {
  let movieRepository: MovieRepository
  
  init(movieRepository: MovieRepository) {
    self.movieRepository = movieRepository
  }
  
  func search(query: String, completion: @escaping (Result<MoviesPage, Error>) -> Void) {
    movieRepository.fetch(query: query, completion: completion)
  }
}
