//
//  MovieController.swift
//  MovieSearch
//
//  Created by Justin Carver on 9/9/16.
//  Copyright © 2016 Justin Carver. All rights reserved.
//

import Foundation
import UIKit

class MovieController {
    
    static let baseURL = NSURL(string: "http://api.themoviedb.org/3/search/movie")
    static let posterURL = NSURL(string:"http://image.tmdb.org/t/p/w500")
    
    static func getMovies(searchTerm: String, completion: (movies: [Movie]?) -> Void) {
        
        let urlParameters = ["api_key": "4cc920dab8b729a619647ccc4d191d5e", "query": "\(searchTerm)"]
        
        guard let url = baseURL else { completion(movies: []); return }
        
        NetworkController.performRequestForURL(url, httpMethod: .Get, urlParameters: urlParameters, body: nil) { (data, error) in
            if error != nil {
                print(error?.localizedDescription)
                completion(movies: [])
                return
            }
            
            guard let data = data, JSONDictionary = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String: AnyObject], resultsArrayOfDictionary = JSONDictionary["results"] as? [[String: AnyObject]] else { completion(movies: []); return }
            
            let Movies = resultsArrayOfDictionary.flatMap { Movie(dictionary: $0) }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(movies: Movies)
            })
        }
    }
    
    static func getPoster(movie: Movie, completion: (poster: UIImage?) -> Void) {
        
        guard let url = posterURL?.URLByAppendingPathComponent("\(movie.imageEndPoint)") else { completion(poster: nil); return }
        
        ImageController.imageForURL(url.absoluteString) { (image) in
            
            guard let image = image else {
                completion(poster: nil)
                return
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(poster: image)
            })
        }
    }
}