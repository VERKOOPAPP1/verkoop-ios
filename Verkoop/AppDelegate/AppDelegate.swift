//
//  AppDelegate.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit
import Firebase
import Branch
import Stripe

//pk_test_IkEuiX8PBSrxqDOnx7W79ubE006HXByoRc
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var fbHandler: FacebookLoginManager?
    var googlePlusHandler: GooglePlusLoginManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        setTabBarAppearance()
        checkForAutoLogin()
        fbHandler = FacebookLoginManager(application: application, launchOptions: launchOptions)
        googlePlusHandler = GooglePlusLoginManager(application: application, launchOptions: launchOptions)
        STPPaymentConfiguration.shared().appleMerchantIdentifier = "merchant.verkoop.com"
        Stripe.setDefaultPublishableKey("pk_live_0QE5t1AQdS0YOx0xAzfzd8Dq00AYl5mZ6X")
        handleDeepLinking(launchOptions: launchOptions)
        UIApplication.shared.statusBarView?.backgroundColor =  kAppDefaultColor
        return true
    }
    
    func checkForAutoLogin() {
        if let _ = Constants.sharedUserDefaults.value(forKey: UserDefaultKeys.kUserId) as? Int  {
            if let screen = Constants.sharedUserDefaults.value(forKey: UserDefaultKeys.screen) as? String {
                registerForPushNotifications()
                if screen == CurrentScreen.category.rawValue {
                    switchToSelectCategory()
                } else if screen == CurrentScreen.option.rawValue {
                    switchToOptions()
                } else if screen == CurrentScreen.dashboard.rawValue {
                    switchToHomeVC()
                } else {
                    DisplayBanner.show(message: DebugMessages.wrongScreen)
                }
            } else {
                DisplayBanner.show(message: DebugMessages.wrongScreen)
            }
        } else {
            switchToLoginVC()
        }
        DocumentManager.sharedManager.saveAppDataCache { (status) in
            
        }
    }
    
    func handleDeepLinking(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        //Handle Deep Linking
        if let branch: Branch = Branch.getInstance() {
            //        Branch.setUseTestBranchKey(true)
            //        Branch.getInstance()?.validateSDKIntegration()
            branch.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {params, error in
                guard let data = params as? [String: AnyObject] else { return }
                //            let alert = UIAlertController(title: "Deep link data", message: "\(data)", preferredStyle: .alert)
                //            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                //            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                guard let options = data["type"] as? String else { return }
                switch options {
                case "1":
                    Console.log(data["product_id"])
                case "2":
                    Console.log(data["item_id"])
                default: break
                }
                
                //            if error == nil &&  params!["product_id"] != nil {
                //                print("params: %@", params as? [String: AnyObject] ?? {})
                //                let alertVC = UIAlertController(title: "Branch Deep Link", message: String.getString(params!["item_id"]), preferredStyle: .alert)
                //                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                //                alertVC.addAction(okAction)
                //                self.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
                //            } else {
                //                let alertVC = UIAlertController(title: "Branch Deep Link", message: String.getString(error?.localizedDescription), preferredStyle: .alert)
                //                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                //                alertVC.addAction(okAction)
                //                self.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
                //                // load your normal view
                //            }
            })
        }
    }
    
    func switchToSelectCategory() {
        let vc = SelectCategoryVC.instantiate(fromAppStoryboard: .selection)
        let nc = SwipeableNavigationController(rootViewController: vc)
        nc.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = nc
    }
    
    func switchToOptions() {
        let vc = SelectOptionsVC.instantiate(fromAppStoryboard: .selection)
        let nc = SwipeableNavigationController(rootViewController: vc)
        nc.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = nc
    }
    
    func switchToHomeVC() {
        let vc = DashboardTabBarController.instantiate(fromAppStoryboard: .home)
        let nc = SwipeableNavigationController(rootViewController: vc)
        nc.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = nc
    }
    
    func switchToLoginVC() {
        let vc = OnboardingVC.instantiate(fromAppStoryboard: .registration)
        let nc = SwipeableNavigationController(rootViewController: vc)
        nc.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = nc
    }
    
    func setSwipe(enabled: Bool, navigationController: UINavigationController?){
        if let nav = navigationController as? SwipeableNavigationController {
            nav.isSwipeEnabled = enabled
        }
    }
    
    func setTabBarAppearance() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.kAppDefaultFontBold(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.kAppDefaultFontBold(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor(hexString: "#e5a6a7")], for: .normal)        
    }
    
    func logout() {
        if let rootNC = window?.rootViewController as? UINavigationController {
            let vc = LoginVC.instantiate(fromAppStoryboard: .registration)
            var viewControllers = rootNC.viewControllers
            viewControllers.insert(vc, at: 0)
            rootNC.viewControllers = viewControllers
            rootNC.popToRootViewController(animated: true)
        }
        logoutUser()
    }
    
    func logoutUser() {
        if let loginType = Constants.sharedUserDefaults.value(forKey: UserDefaultKeys.loginType) as? String {
            if loginType == LoginType.normal.rawValue {
                
            } else if loginType == LoginType.facebook.rawValue {
                fbHandler?.logoutUser()
            } else if loginType == LoginType.google.rawValue {
                googlePlusHandler?.logout()
            }
            clearUserDefaults()
            CoreDataManager.clearDB()
        }
        registerForPushNotifications()
    }
    
    func clearUserDefaults() {
        if let domain = Bundle.main.bundleIdentifier {
            let token = Constants.sharedUserDefaults.getDeviceToken()
            Constants.sharedUserDefaults.removePersistentDomain(forName: domain)
            if token.count > 0 {
                Constants.sharedUserDefaults.set(token, forKey: UserDefaultKeys.kDeviceToken)
            }
        }
    }
    
    //Handle Deep Linking
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // pass the url to the handle deep link call
        if let branchHandled = Branch.getInstance()?.application(application,
                                                             open: url,
                                                             sourceApplication: sourceApplication,
                                                             annotation: annotation
            ) {
            if (!branchHandled) {
                // If not handled by Branch, do other deep link routing for the Facebook SDK, Pinterest SDK, etc
            }
        }
 
        return true
    }
    
    // Respond to Universal Links
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        Branch.getInstance()?.continue(userActivity)
        return true
    }
    
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
//        pass the url to the handle deep link call
        Branch.getInstance()?.continue(userActivity)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        UIPasteboard.general.setValue("", forPasteboardType: UIPasteboard.Name.general.rawValue)
        SocketHelper.shared.disconnect()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        SocketHelper.shared.connect()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func getShareableLink(controller: UIViewController, shareId: String, type: Int, titleName: String, imageUrl: String) {
        let branchUniversalObject = BranchUniversalObject(canonicalIdentifier: "Verkoop/App")
        branchUniversalObject.imageUrl = imageUrl
        branchUniversalObject.title = titleName
        branchUniversalObject.publiclyIndex = true
        branchUniversalObject.locallyIndex = true
        
        let linkProperties = BranchLinkProperties()
        linkProperties.feature = "share"
        linkProperties.channel = "facebook"
        if type == 1 { //When Sharing the product
            branchUniversalObject.contentDescription = "check this product"
            branchUniversalObject.contentMetadata.customMetadata["product_id"] = shareId
            linkProperties.addControlParam("product_id", withValue: shareId)
        } else { //When Sharing the Profile.
            branchUniversalObject.contentDescription = "Check my profile"
            branchUniversalObject.contentMetadata.customMetadata["user_id"] = shareId
            linkProperties.addControlParam("user_id", withValue: shareId)
        }
        branchUniversalObject.getShortUrl(with: linkProperties) { (url, error) in
            if error == nil, let urlString = url {
                Console.log("Deep Link URL : \(urlString)")
                branchUniversalObject.showShareSheet(with: linkProperties, andShareText: "Check out this link", from: controller) { (activityType, completed) in
                    if (completed) {
                        Console.log(String(format: "Product Shared using: %@", activityType!))
                    } else {
                        print("Link sharing cancelled")
                    }
                }
            }
        }
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 1009
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
    }
}
