//
//  AppDelegate+Notification.swift
//  Verkoop
//
//  Created by Vijay on 07/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func registerForPushNotifications() {
        self.configureRichNotifications()
    }
    
    func configureRichNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted:Bool, error:Error?) in
            if error != nil {
                debugPrint((error?.localizedDescription)!)
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    //MARK:- UIApplicationDelegate
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // application is unused
        var token = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        debugPrint(token)
        Constants.sharedUserDefaults.set(token, forKey: UserDefaultKeys.kDeviceToken)
        self.updateDeviceTokenAPI(token: token)
    }
    
    //MARK:- Remote/Local Notification Delegates
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let dict = userInfo["aps"] as? NSDictionary
        debugPrint(dict ?? "not avail")
        debugPrint("didReceiveRemoteNotification \(userInfo.description)")
        //        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if notification.request.content.categoryIdentifier == "localChatNotification" {
            let dict = notification.request.content.userInfo
            debugPrint(dict)
        }
        completionHandler([.alert,.badge,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if UIApplication.shared.applicationState == .active {
            handleNotificationAction(response: response)
        } else if UIApplication.shared.applicationState == .inactive {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.35) {
                self.handleNotificationAction(response: response)
            }
        }
    }
    
    func handleNotificationAction(response: UNNotificationResponse) {
        if let dict = response.notification.request.content.userInfo as? [String: Any], let aps = dict["aps"] as? [String: Any], let alert = aps["alert"] as? [String : Any] {
            if let type = alert["type"] as? Int {
                if type == 1 || type == 3 || type == 4 || type == 6 { //Item Detail
                    let itemId = String.getString(alert["item_id"])
                    let productVC = ProductDetailVC.instantiate(fromAppStoryboard: .categories)
                    if type == 3 || type == 6 { //Like and Comment
                        productVC.isMyItem = true
                    } else {
                        productVC.isMyItem = false
                    }
                    productVC.itemId = String.getString(itemId)
                    navigateThroughPushnotification(controller: productVC)
                } else if type == 2 { //Other Profile
                    let userId = String.getString(alert["user_id"])
                    let profileVC = OtherUserProfileVC()
                    profileVC.userId = String.getString(userId)
                    profileVC.userName = ""
                    navigateThroughPushnotification(controller: profileVC)
                } else if type == 5 { //Wallet
                    let walletVC = WalletVC.instantiate(fromAppStoryboard: .advertisement)
                    navigateThroughPushnotification(controller: walletVC)
                } else if type == 7 { //All chat
                    let inboxVC = InboxVC.instantiate(fromAppStoryboard: .chat)
                    navigateThroughPushnotification(controller: inboxVC)
                }
            } else {
                let inboxVC = InboxVC.instantiate(fromAppStoryboard: .chat)
                navigateThroughPushnotification(controller: inboxVC)
            }
        }
    }
    
    func navigateThroughPushnotification(controller: UIViewController) {
        if let rootVC = window?.rootViewController as? SwipeableNavigationController {
            DispatchQueue.main.async {
                rootVC.pushViewController(controller, animated: true)
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Console.log(userInfo)
        if application.applicationState == .active {
            //app is currently active, can update badges count here
        } else if application.applicationState == .background {
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
        } else if application.applicationState == .inactive {
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
        }
    }
    
    func updateDeviceTokenAPI(token:String) {
        let params = [
            "user_id" : Constants.sharedUserDefaults.getUserId(),
            "device_id" : token,
            "device_type" : "2",
        ]
        let urlString = MethodName.updateDeviceToken
        ApiManager.request(path:urlString, parameters: params, methodType: .post) { [weak self](result) in
            switch result {
            case .success(_):
                Console.log("Device Token Sent Successfully")
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func logoutService() {
        let endPoint = MethodName.logout
        let params = [
            "user_id" : Constants.sharedUserDefaults.getUserId()
        ]
        ApiManager.request(path:endPoint, parameters: params, methodType: .post) { [weak self](result) in
            switch result {
            case .success(let data):
                if let genericMessage: GenericResponse = self?.handleSuccess(data: data) {
                    DisplayBanner.show(message: genericMessage.message)
                    self?.logout()
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func deactivateAccountService() {
        let endPoint = MethodName.deactivateAccount
        ApiManager.request(path:endPoint, parameters: nil, methodType: .put) { [weak self](result) in
            switch result {
            case .success(let data):
                if let genericMessage: GenericResponse = self?.handleSuccess(data: data) {
                    DisplayBanner.show(message: genericMessage.message)
                    self?.logout()
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func handleSuccess<T: Decodable>(data: Any) -> T? {
        if let data = data as? [String : Any] {
            do {
                let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                let decoder = JSONDecoder()
                do {
                    let data = try decoder.decode(T.self, from: data)
                    return data
                } catch {
                    Console.log(error.localizedDescription)
                }
            } catch {
                Console.log(error.localizedDescription)
            }
        } else {
            Console.log(ErrorMessages.somethingWentWrong)
        }
        return nil
    }
    
    func handleFailure(error: Error?){
        if let error = error {
            Console.log(error.localizedDescription)
        } else {
            Console.log(ErrorMessages.somethingWentWrong)
        }
    }
    
    func scheduleNotifications(chat:[String:Any]) {
        //        let content = UNMutableNotificationContent()
        //        let requestIdentifier = "localNotification"
        //
        //        var userInfo = [String:String]()
        //        userInfo[Constants.ServerKey.senderId] = chat[Constants.ServerKey.senderId].stringValue
        //        userInfo[Constants.ServerKey.userName] = chat[Constants.ServerKey.userName].stringValue
        //        userInfo[Constants.ServerKey.profilePic] = chat[Constants.ServerKey.profilePic].stringValue
        //        userInfo[Constants.ServerKey.type] = "1"
        //
        //        content.userInfo = userInfo
        //        //        content.badge = 1
        //        content.title = chat[Constants.ServerKey.userName].stringValue
        //        if chat[Constants.ServerKey.type].stringValue == "1" {
        //            content.body = chat[Constants.ServerKey.message].stringValue
        //        } else {
        //            content.body = "📷 Image"
        //        }
        //        content.categoryIdentifier = "localChatNotification"
        //        content.sound = UNNotificationSound.default()
        //
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        //
        //        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        //        UNUserNotificationCenter.current().add(request) { (error:Error?) in
        //
        //            if error != nil {
        //                print(error!.localizedDescription)
        //            }
        //            print("Notification Register Success")
        //        }
        //    }
    }
}
