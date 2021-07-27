//
//  MovieDetailViewController.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var watchlistBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var favoriteBarButtonItem: UIBarButtonItem!
    
    var moviex: Movie!
   
    

    
    var isWatchlist: Bool {
        return MovieModel.watchlist.contains(moviex)
    }
    
    var isFavorite: Bool {
        return MovieModel.favorites.contains(moviex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = moviex.title
       
        imageView.image = UIImage(named: moviex.posterPath! )
        
        toggleBarButton(watchlistBarButtonItem, enabled: isWatchlist)
        toggleBarButton(favoriteBarButtonItem, enabled: isFavorite)
        
    }
    
    @IBAction func watchlistButtonTapped(_ sender: UIBarButtonItem) {
        print(isWatchlist)
        //switch
        toggleBarButton(watchlistBarButtonItem, enabled: !isWatchlist)
        print(isWatchlist)
        if isWatchlist == true {
            //present in list delete it local array first
            print("delete")
          
            MovieModel.watchlist.removeAll { movie in
                movie.id == moviex.id
            }
            changeWatchlist(movie: moviex)
          
            print(isWatchlist)
            
        }
        else{
            //add the movie to watchlist
            print("add")
           
            MovieModel.watchlist.append(moviex)
            changeWatchlist(movie: moviex)
            
        }
        
        
        
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        print(isFavorite)
        toggleBarButton(favoriteBarButtonItem, enabled: !isFavorite)
        if isFavorite == true {
            //present in list delete it local array first
            print("delete")
            MovieModel.favorites.removeAll { movie in
                movie.id == moviex.id
            }
            ChangeFavorite(movie: moviex)
          
            print(isFavorite)
            
        }
        else{
            //add the movie to favorite
            print("add")
           
            MovieModel.favorites.append(moviex)
            ChangeFavorite(movie: moviex)
            
        }
        
        

    }
    
    func toggleBarButton(_ button: UIBarButtonItem, enabled: Bool) {
        if enabled {
            button.tintColor = UIColor.primaryDark
        } else {
            button.tintColor = UIColor.gray
        }
    }
    
    func changeWatchlist(movie :Movie){
   
        TMDBClient.markWatchListRequest(mediaID: movie.id, mark: isWatchlist) { res, error in
            if error == nil {
                print( "Marking in watch list is successful")
            }
        }
        
        
    }

    func ChangeFavorite(movie :Movie){
        TMDBClient.markFavoriteRequest(mediaID: movie.id, mark: isFavorite) { res, error in
            if error == nil {
                print( "Marking in favorite list is successful")
            }
        }
        
        
    }
   
    
   
    
}
