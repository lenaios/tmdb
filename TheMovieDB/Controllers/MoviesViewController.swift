//
//  ViewController.swift
//  TheMovieDB
//
//  Created by Ador on 2021/08/28.
//

import UIKit

class MoviesViewController: UIViewController {

  @IBOutlet weak var moviesTableView: UITableView!
  
  weak var coordinator: Coordinator?
  
  private let searchViewController = UISearchController(searchResultsController: nil)
  
  @Dependency var moviesViewModel: MoviesViewModel
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    moviesTableView.rowHeight = 120
    moviesTableView.dataSource = self
    moviesTableView.delegate = self
    
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

extension MoviesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    let movie = moviesViewModel.item(for: indexPath.item)
    guard let coordinator = coordinator as? DefaultCoordinator else { return }
    coordinator.showMovieDetail(movie: movie)
  }
}
