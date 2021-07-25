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
        print("getWatchlist")
        
        self.taskForGetRequest(url: Endpoints.getWatchlist.url, responseType: MovieResults.self) { response, error in
            if let response = response{
                print(response.results)
                completion(response.results, nil)
                return
            }
            completion([],error)
        }
    }
    
    
    class func getRequestToken(completion: @escaping(Bool, Error?) -> Void)
    {
        
        self.taskForGetRequest(url: Endpoints.getRequestToken.url, responseType: RequestTokenResponse.self) { response, error in
            if let response = response{
                
                TMDBClient.Auth.requestToken = response.request_token
                
                completion(true,nil)
                return
            }
            completion(false,error)
        }
    
    }
    
    //Post request with Body --> Using URLRequuest for this
    class func authenticateToken(body : LoginRequest,completion: @escaping(Bool, Error?) -> Void)
    
    {
        TMDBClient.taskForPutRequest(url: Endpoints.authenticateRequestToken.url, httpMethod: "POST", body: body, responseType: RequestTokenResponse.self) { res, error in
            if let res = res{
                self.Auth.requestToken = TMDBClient.Auth.requestToken
                completion(true,nil)
                return
                }
            
            completion(false,error)
        }
        
        
    }
    
     class func sessionIdRequest(completion: @escaping(Bool, Error?) -> Void)
     {
        let body = PostSession(request_token: TMDBClient.Auth.requestToken)
        TMDBClient.taskForPutRequest(url:  Endpoints.sessionIdRequest.url, httpMethod: "POST", body: body, responseType: SessionResponse.self) { res, error in
            if let res = res{
                TMDBClient.Auth.sessionId = res.session_id
                completion(true,nil)
                return
                }
            
            completion(false,error)
        }
     }
    
    class func logOutUser(completion: @escaping() -> Void)
    {  let body = logOutBody(session_id: TMDBClient.Auth.sessionId)
        self.taskForPutRequest(url:  Endpoints.logOut.url, httpMethod: "DELETE", body: body, responseType: SessionResponse.self){_,_ in 
             TMDBClient.Auth.sessionId = ""
                TMDBClient.Auth.requestToken = ""
                completion()
               
        }
               
        
}
    
    
    class func taskForGetRequest<ResponseType:Decodable>(url: URL, responseType : ResponseType.Type, completion: @escaping  ((ResponseType? ,Error?) -> Void ))
    
    {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion( nil  , error)
                return
            }
            let decoder = JSONDecoder()
            do {
               
                
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                completion(nil, error)
                }}
        }
        task.resume()
        
    }
    
    //two generics types- RequestType : Encodable
    //                    ResponseType : Decodable
    //Parameters: 1)url
    //            2)httpmethod
    //            3)body --of type RequestType
    //            4)responseType ---- of type ResponseType.type
    class func taskForPutRequest<RequestType : Encodable , ResponseType:Decodable>(url: URL, httpMethod : String ,body : RequestType ,responseType : ResponseType.Type, completion: @escaping  ((ResponseType? ,Error?) -> Void ))
    {
        var myRequest = URLRequest(url :url)
           myRequest.httpMethod = httpMethod
           myRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
      //  let body = PostSession(request_token: TMDBClient.Auth.requestToken)
        myRequest.httpBody = try! JSONEncoder().encode(body.self)
           
           let task = URLSession.shared.dataTask(with: myRequest) { data, response, error in
               guard let data = data else {
                   print("Session Id failed")
                   ;completion(nil,error)
                   return
               }
             
               let decorder = JSONDecoder()
               do{
                   let res = try decorder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                completion(res, nil)
                }
               }
               catch {
                DispatchQueue.main.async {
                   completion(nil, error)
                   
                }}
               
           
           }
           task.resume()
    }
 
}
