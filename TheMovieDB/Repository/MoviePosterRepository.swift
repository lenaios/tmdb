//
//  MoviePosterRepository.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/29.
//

import Foundation

protocol MoviePosterRepository {
  func fetch(image: String, completion: @escaping (Result<Data, Error>) -> Void)
}

final class DefaultMoviePosterRepository: MoviePosterRepository {
  let networkService: NetworkService
  
  private let baseURL = "http://image.tmdb.org/t/p/w185"
  
  init(networkService: NetworkService) {
    self.networkService = networkService
  }
  
  func fetch(image: String, completion: @escaping (Result<Data, Error>) -> Void) {
    guard let url = URL(string: baseURL + image) else { return }
    let request = URLRequest(url: url)
    networkService.request(request) { result in
      switch result {
      case .success(let data):
        completion(.success(data))
      case .failure(let error):
        completion(.failure(error))
      }
    }.resume()
  }
}
