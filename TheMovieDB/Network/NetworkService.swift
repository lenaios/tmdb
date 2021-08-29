//
//  NetworkService.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/28.
//

import Foundation

protocol NetworkCancellable {
  func resume()
  func cancel()
}

protocol NetworkService {
  typealias Completion = (Result<Data, Error>) -> Void

  func request(_ request: URLRequest, completion: @escaping Completion) -> NetworkCancellable
}

final class DefaultNetworkService: NetworkService {
  private let session: URLSession
  
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  func request(_ request: URLRequest, completion: @escaping Completion) -> NetworkCancellable {
    return session.dataTask(with: request) { data, _, error in
      guard let data = data, error == nil else {
        completion(.failure(error!))
        return
      }
      completion(.success(data))
    }
  }
  
  func request(_ url: URL, completion: @escaping Completion) -> NetworkCancellable {
    return session.dataTask(with: url) { data, _, error in
      guard let data = data, error == nil else {
        completion(.failure(error!))
        return
      }
      completion(.success(data))
    }
  }
}

extension URLSessionTask: NetworkCancellable {
  func cancel() { }
}
