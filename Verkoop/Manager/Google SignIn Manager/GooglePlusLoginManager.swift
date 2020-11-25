//
//  GooglePlusLoginManager.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 04/12/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//
import GoogleSignIn

protocol StateDelegate: class {
    func present(viewController: UIViewController)
    func dismiss(viewController: UIViewController)
    func error()
    func user(data: [String: String])
}

class GooglePlusLoginManager: NSObject {
    
    weak var delegate: StateDelegate?
    var presentingVC: UIViewController?
    
    init(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        GIDSignIn.sharedInstance().clientID = "169900089915-tec7i92d5g94qdvfjuruvfiefdl0jvd4.apps.googleusercontent.com"
    }
    
    func loginWithGooglePlus() {
        if let controller = presentingVC {
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance()?.presentingViewController = controller
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    func logout() {
        GIDSignIn.sharedInstance()?.signOut()
    }
}

extension GooglePlusLoginManager: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            
        } else {
            if let user = user {
                var params = [String: String]()
                if let userId = user.userID {
                    params[ServerKeys.socialId] = userId
                }
                if let name = user.profile.name {
                    params[ServerKeys.userName] = name
                }
                if let email = user.profile.email {
                    params[ServerKeys.email] = email
                }
                params[ServerKeys.requestType] = ServerKeys.social
                delegate?.user(data: params)
                return
            }
        }
        delegate?.error()
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        Console.log("Tseet")
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        delegate?.present(viewController: viewController)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        delegate?.dismiss(viewController: viewController)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        Console.log(error.localizedDescription)
    }
}
