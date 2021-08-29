//
//  MovieRepository.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/28.
//

import Foundation

protocol MovieRepository {
  func fetch(query: String, completion: @escaping (Result<MoviesPage, Error>) -> Void)
}

final class DefaultMovieRepository: MovieRepository {
  let networkService: NetworkService
  
  init(networkService: NetworkService) {
    self.networkService = networkService
  }
  
  func fetch(query: String, completion: @escaping (Result<MoviesPage, Error>) -> Void) {
    let query = URLQueryItem(name: "query", value: query)
    let apiKey = URLQueryItem(name: "api_key", value: apiKey())
    let endpoint = Endpoint(path: "/3/search/movie", query: [query, apiKey])
    let request = URLRequest(url: endpoint.url)
    let decoder = JSONDecoder()
    networkService.request(request) { result in
      switch result {
      case .success(let data):
        guard
          let page = try? decoder.decode(MoviesPage.self, from: data)
        else {
          return
        }
        completion(.success(page))
      case .failure(let error):
        fatalError(error.localizedDescription)
      }
    }.resume()
  }
  
  private func apiKey() -> String {
    guard
      let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
      let xml = FileManager.default.contents(atPath: path),
      let config = try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil) as? [String: String]
    else {
      fatalError()
    }
    let apiKey = config["API_KEY"]
    return apiKey!
  }
}

protocol Cancellable {
  func cancel()
}
