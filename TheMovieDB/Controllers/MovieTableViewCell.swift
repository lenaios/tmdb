//
//  MovieTableViewCell.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/29.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
  @IBOutlet weak var poster: UIImageView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var subtitle: UILabel!
  @IBOutlet weak var rate: UILabel!
  
  @Dependency var repository: DefaultMoviePosterRepository
  
  func fill(_ item: MovieViewModel) {
    repository.fetch(image: item.poster) { result in
      switch result {
      case .success(let data):
        DispatchQueue.main.async {
          self.imageView?.image = UIImage(data: data)
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
    self.title.text = item.title
    self.subtitle.text = item.genre.joined(separator: ", ")
    self.rate.text = item.rate
  }
}
