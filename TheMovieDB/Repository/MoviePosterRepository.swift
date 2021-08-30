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
  let cache: ImageCache
  
  private let baseURL = "http://image.tmdb.org/t/p/w185"
  
  init(networkService: NetworkService, cache: ImageCache) {
    self.networkService = networkService
    self.cache = cache
  }
  
  func fetch(image: String, completion: @escaping (Result<Data, Error>) -> Void) {
    if cache.exist(image) {
      guard let data = cache.image(image) else {
        completion(.failure(MoviePosterRepositoryError.noData))
        return
      }
      completion(.success(data))
      return
    }
    
    guard let url = URL(string: baseURL + "/" + image) else { return }
    let request = URLRequest(url: url)
    networkService.request(request) { result in
      switch result {
      case .success(let data):
        completion(.success(data))
        self.cache.save(data: data, atPath: image)
      case .failure(let error):
        completion(.failure(error))
      }
    }.resume()
  }
}

enum MoviePosterRepositoryError: Error {
  case noData
}
