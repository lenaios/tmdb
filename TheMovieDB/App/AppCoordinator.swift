//
//  AppCoordinator.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/29.
//

import UIKit

protocol Coordinator: AnyObject {
  func start()
}

class DefaultCoordinator: Coordinator {
  let navigation: UINavigationController
  
  init(navigation: UINavigationController) {
    self.navigation = navigation
  }
  
  func start() {
    let view: MoviesViewController = MoviesViewController.instantiate()
    view.coordinator = self
    navigation.pushViewController(view, animated: true)
  }
  
  func showMovieDetail(movie: Movie) {
    let view: MovieDetailViewController = MovieDetailViewController.instantiate()
    view.movie = MovieDetailViewModel(movie: movie)
    navigation.pushViewController(view, animated: true)
  }
}
