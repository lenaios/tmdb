//
//  AppDelegate.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    setupDependency()
    return true
  }
  
  func setupDependency() {
    let networkService = DefaultNetworkService()
    let movieRepository = DefaultMovieRepository(networkService: networkService)
    let moviePosterRepository = DefaultMoviePosterRepository(networkService: networkService)
    let movieSearchUseCase = DefaultMovieSearchUseCase(movieRepository: movieRepository)
    let moviesViewModel = MoviesViewModel(movieSearchUseCase: movieSearchUseCase)
    
    DIContainer.shared.register(networkService)
    DIContainer.shared.register(movieRepository)
    DIContainer.shared.register(moviePosterRepository)
    DIContainer.shared.register(movieSearchUseCase)
    DIContainer.shared.register(moviesViewModel)
  }
}

