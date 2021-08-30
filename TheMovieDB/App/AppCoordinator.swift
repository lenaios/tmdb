//
//  AppCoordinator.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/29.
//

import UIKit

protocol Coordinator {
  func start()
}

class DefaultCoordinator: Coordinator {
  let navigation: UINavigationController
  
  init(navigation: UINavigationController) {
    self.navigation = navigation
  }
  
  func start() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let identifier = String(describing: MoviesViewController.self)
    let view = storyboard.instantiateViewController(withIdentifier: identifier)
    navigation.pushViewController(view, animated: true)
  }
}
