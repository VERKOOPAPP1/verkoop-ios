//
//  FacebookLoginManager.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import FBSDKLoginKit
class FacebookLoginManager {
    
    enum Result<T> {
        case success(T)
        case failure(Error?)
        case errorMessages(String)
    }
 
    init(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func canHandleURL(_ app: UIApplication, _ url: URL, _ options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication: String? = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        return ApplicationDelegate.shared.application(app, open: url, sourceApplication: sourceApplication, annotation: nil)
    }
    
    func loginWithFacebook(viewController: UIViewController,responseResult: @escaping (Result<Any>) -> ()) {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: viewController) { (result, error) in
            if let error = error{
                responseResult(Result.failure(error))
                return
            }
            if result?.grantedPermissions != nil {
                if let result = result {
                    responseResult(Result.success(result))
                }else{
                    responseResult(Result.errorMessages("No user Found"))
                }
            } else {
                 responseResult(Result.errorMessages("Login Cancelled"))
                
            }
        }
    }
    
    func fetchUserData(responseResult: @escaping (Result<Any>) -> ()) {
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if let error = error {
                    responseResult(Result.failure(error))
                     return
                }
                if let result = result {
                    responseResult(Result.success(result))

                }else{
                    responseResult(Result.errorMessages("No userdata found"))

                }
            })
        } else {
            responseResult(Result.errorMessages("Invalid user"))
        }
    }
    
    func logoutUser(){
        LoginManager().logOut()
    }
}
