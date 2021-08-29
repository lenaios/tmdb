//
//  ViewController.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/28.
//

import UIKit

class MoviesViewController: UIViewController {

  @IBOutlet weak var moviesTableView: UITableView!
  
  private let searchViewController = UISearchController(searchResultsController: nil)
  
  let moviesViewModel = MoviesViewModel(movieSearchUseCase: DefaultMovieSearchUseCase(movieRepository: DefaultMovieRepository(networkService: DefaultNetworkService())))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    moviesTableView.dataSource = self
    
    setupSearchController()
    bindUI()
  }
  
  private func bindUI() {
    moviesViewModel.items.bind { _ in
      DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        self.moviesTableView.reloadData()
      }
    }
  }
  
  private func setupSearchController() {
    searchViewController.searchBar.delegate = self
    searchViewController.hidesNavigationBarDuringPresentation = false
    searchViewController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchViewController
  }
}

extension MoviesViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let query = searchBar.text, !query.isEmpty else { return }
    moviesViewModel.load(query: query)
  }
}

extension MoviesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    moviesViewModel.items.value.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Movie Cell", for: indexPath) as! MovieTableViewCell
    let item = moviesViewModel.items.value[indexPath.row]
    cell.fill(item)
    return cell
  }
}

final class MovieTableViewCell: UITableViewCell {
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var overview: UILabel!
  
  let repository = DefaultMoviePosterRepository(networkService: DefaultNetworkService())
  
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
    self.overview.text = item.overview
  }
}