//
//  SceneDelegate.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/28.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var coordinator: Coordinator?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: scene)
    let navigation = UINavigationController()
    coordinator = DefaultCoordinator(navigation: navigation)
    window.rootViewController = navigation
    window.makeKeyAndVisible()
    coordinator?.start()
    self.window = window
  }
}

