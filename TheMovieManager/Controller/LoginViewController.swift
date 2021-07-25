//
//  LoginViewController.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    
   
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        
//        emailTextField.text = ""
//        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {

       
        TMDBClient.getRequestToken(completion: self.handleRequestTokenResponse(response:error:))
        
        }
    
    
            
    func handleRequestTokenResponse(response : Bool , error : Error?){
        if response{
            print(TMDBClient.Auth.requestToken)
            
            DispatchQueue.main.async {
              
            
              let body = LoginRequest(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", request_token: TMDBClient.Auth.requestToken)

           TMDBClient.authenticateToken(body: body,completion: self.handleLoginResponse(success:error:))
            }
        }
        else{
            print(error?.localizedDescription)
        }
        
            
        
    }
        func handleLoginResponse(success : Bool,error : Error?)
        {  if success {
            
            DispatchQueue.main.async {
              
                
        
                TMDBClient.sessionIdRequest(completion: self.handleSessionResponse(success:error:))
                
            }}
        else{
            print(error!.localizedDescription)
        }
        }
            
    func handleSessionResponse(success : Bool,error : Error?)
    {
        if success{
            print(TMDBClient.Auth.sessionId)
        
            DispatchQueue.main.async {
                print("You are logged in")
               
                    self.performSegue(withIdentifier: "completeLogin", sender: nil)
    
            }}
        else{
            print(error!.localizedDescription)
        }
    }
    
    
    @IBAction func loginViaWebsiteTapped() {
        
        //FOR WEB AUTHENTICATION:
       // 1) CREATE REQUEST TOKEN
        //2) AUTHENTICATE ON THE URL(WEB) SEPECIFIED IN API AND ADD THE RETURN URL TO REDIRECT THE USER BACK TO THE APPLICATION
        
        TMDBClient.getRequestToken { success, error in
            if success{
                print("token is created")
                DispatchQueue.main.async {
                
                //open the url using uiapplication shared instance's open func
                UIApplication.shared.open(TMDBClient.Endpoints.webLogin.url, options: [:], completionHandler: nil)
                //handle this func in AppDelegate
            }
            }}
      
    }
    
}
