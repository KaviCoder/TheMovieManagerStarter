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
        
        TMDBClient.markWatchListRequest(mediaID: self.moviex.id, mark: !isWatchlist,completion: HandleChangeWatchlistResponse(success:error:))
        
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        
        TMDBClient.markFavoriteRequest(mediaID: self.moviex.id, mark: !isFavorite,completion: HandleChangeFavoriteResponse(success:error:))
        
        
    }
    
    func toggleBarButton(_ button: UIBarButtonItem, enabled: Bool) {
        if enabled {
            button.tintColor = UIColor.primaryDark
        } else {
            button.tintColor = UIColor.gray
        }
    }
    
    func HandleChangeWatchlistResponse(success :Bool, error:Error?){
        if success
        {  toggleBarButton(watchlistBarButtonItem, enabled: !isWatchlist)
            if isWatchlist{
                //It was present in watchlist and now we removed from the watchlist using API call and we need to take care in the app too
                MovieModel.watchlist.removeAll { m in
                    m.id == moviex.id
                }
            }
            else{
                //if the item is not in the watchlist means the user added to watchlist by tapping on the button so added locally to update App UI accordingly.
                MovieModel.watchlist.append(moviex)
            }
            
        }
        else{
            print("cannot change the Watchlist")
            
        }
        
        
        
        
    }
    func HandleChangeFavoriteResponse(success :Bool, error:Error?){
        if success
        {  toggleBarButton(favoriteBarButtonItem, enabled: !isFavorite)
            if isFavorite{
                //It was present in watchlist and now we removed from the watchlist using API call and we need to take care in the app too
                MovieModel.favorites.removeAll { m in
                    m.id == moviex.id
                }
            }
            else{
                //if the item is not in the watchlist means the user added to watchlist by tapping on the button so added locally to update App UI accordingly.
                MovieModel.favorites.append(moviex)
            }
            
        }
        else{
            print("cannot change the Favorite")
            
        }
        
        
    }
    
    
}
