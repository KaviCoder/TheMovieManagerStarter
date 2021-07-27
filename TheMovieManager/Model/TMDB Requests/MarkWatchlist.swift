//
//  MarkWatchlist.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
struct MarkWatchlist : Codable{
    let media_type : MediaType.RawValue
    let media_id: Int
    let watchlist : Bool
    
}


