//
//  UIViewController+.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/31.
//

import UIKit


extension UIViewController {
  static func instantiate<T>() -> T {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let identifier = String(describing: self)
    return storyboard.instantiateViewController(withIdentifier: identifier) as! T
  }
}
