//
//  MovieDetailViewController.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/31.
//

import UIKit

class MovieDetailViewController: UIViewController {
  @IBOutlet weak var poster: UIImageView!
  @IBOutlet weak var overview: UILabel!
  
  var movie: MovieDetailViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    title = movie.title
    bindUI()
  }
  
  private func bindUI() {
    movie.posterImage.bind { [weak self] image in
      guard let image = image else { return }
      self?.poster.image = .init(data: image)
    }
    overview.text = movie.overview
  }
}
