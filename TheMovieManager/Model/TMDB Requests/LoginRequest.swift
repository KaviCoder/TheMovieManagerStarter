//
//  Login.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

struct LoginRequest : Codable
{
    let username : String
    let password : String
    let request_token : String
    
    
//    enum CodingKeys : String, CodingKey
//    {
//        case userName = "username"
//        case Password = "password"
//        case requestToken = "request_token"
//    }
}

