//
//  MoviesTableViewController.swift
//  MovieSearch
//
//  Created by Justin Carver on 9/9/16.
//  Copyright © 2016 Justin Carver. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController, UISearchBarDelegate {
    
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchTerm = searchBar.text where !searchTerm.isEmpty else { return }
        
        MovieController.getMovies(searchTerm) { (movies) in
            if let movies = movies {
                self.movies = movies
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = 250
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as? MovieCell
        let movie = movies[indexPath.row]
        
        cell?.TitleLabel.text = movie.title
        cell?.DescriptionLabel.text = movie.description
        cell?.RatingLabel.text = "\(movie.rating)"
        
        
        MovieController.getPoster(movie) { (poster) in
            if let poster = poster {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell?.PosterImage.image = poster
                })
            }
        }
        
        return cell ?? MovieCell()
    }
}
