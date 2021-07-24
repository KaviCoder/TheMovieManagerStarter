//
//  TMDBClient.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
//API Key: 19381fd01caff68fc9b5ed953e9b9fba

class TMDBClient {
    
    static let apiKey = "19381fd01caff68fc9b5ed953e9b9fba"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getWatchlist
        case getRequestToken
        case authenticateRequestToken
        case sessionIdRequest
        case webLogin
        case logOut
        
        var stringValue: String {
            switch self {
            case .getWatchlist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
                
            case .getRequestToken: return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
                
                
            case .authenticateRequestToken: return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
                
            case .sessionIdRequest: return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
            case .webLogin: return "https://www.themoviedb.org/authenticate/" + Auth.requestToken + "?redirect_to=themoviemanager:authenticate"
                //themovieManager is the protocol/scheme and authenticate is the path
            
            case .logOut: return Endpoints.base + "/authentication/session" + Endpoints.apiKeyParam
            }
            
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getWatchlist.url) { data, response, error in
            guard let data = data else {
                completion([], error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(MovieResults.self, from: data)
                completion(responseObject.results, nil)
            } catch {
                completion([], error)
            }
        }
        task.resume()
    }
    
    
    class func getRequestToken(completion: @escaping(Bool, Error?) -> Void)
    {
        let task = URLSession.shared.dataTask(with: Endpoints.getRequestToken.url) { data, response, error in
            guard let data = data else {
                
                completion(false,error)
                return
            }
            
            let decorder = JSONDecoder()
            do{
                let token = try decorder.decode(RequestTokenResponse.self, from: data).request_token
                self.Auth.requestToken = token
                completion(true, nil)
            }
            catch {
                completion(false, error)
                
            }
            
        
        }
        task.resume()
    }
    
    //Post request with Body --> Using URLRequuest for this
    class func authenticateToken(body : LoginRequest,completion: @escaping(Bool, Error?) -> Void)
    { var myRequest = URLRequest(url : Endpoints.authenticateRequestToken.url)
        myRequest.httpMethod = "POST"
        myRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        myRequest.httpBody = try! JSONEncoder().encode(body)
        
        print(myRequest.httpBody)
        
        let task = URLSession.shared.dataTask(with: myRequest) { data, response, error in
            guard let data = data else {
                print("Auth token failed")
                ;completion(false,error)
                return
            }
            print("**********************")
            print(data)
            let decorder = JSONDecoder()
            do{
                let token = try decorder.decode(RequestTokenResponse.self, from: data)
                self.Auth.requestToken = token.request_token
                completion(true, nil)
            }
            catch {
                print("JSON decoding error")
                completion(false, error)
                
            }
            
        
        }
        task.resume()
    }
    
     class func sessionIdRequest(completion: @escaping(Bool, Error?) -> Void)
     {
        var myRequest = URLRequest(url : Endpoints.sessionIdRequest.url)
           myRequest.httpMethod = "POST"
           myRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = PostSession(request_token: TMDBClient.Auth.requestToken)
           myRequest.httpBody = try! JSONEncoder().encode(body)
           
           let task = URLSession.shared.dataTask(with: myRequest) { data, response, error in
               guard let data = data else {
                   print("Session Id failed")
                   ;completion(false,error)
                   return
               }
             
               let decorder = JSONDecoder()
               do{
                   let res = try decorder.decode(SessionResponse.self, from: data)
                self.Auth.sessionId = res.session_id
                   completion(true, nil)
               }
               catch {
                   print("JSON decoding error while session Id fetching")
                   completion(false, error)
                   
               }
               
           
           }
           task.resume()
     }
    
    class func logOutUser()
    {
        var myRequest = URLRequest(url : Endpoints.logOut.url)
           myRequest.httpMethod = "DELETE"
           myRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = logOutBody(session_id: TMDBClient.Auth.sessionId)
           myRequest.httpBody = try! JSONEncoder().encode(body)
           
           let task = URLSession.shared.dataTask(with: myRequest) { data, response, error in
               guard let _ = data else {
                   print("Cannot logout with Session Id failed")
                 
                   return
               }
            //to logout the user
            Auth.requestToken = ""
            Auth.sessionId = ""
            print("Logged out Successfully")
        
    }
    
}
}
