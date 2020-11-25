//
//  CustomApiManager.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 14/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

class CustomApiManager {
    
    typealias APISuccess = (_ resposeData : Any, _ success: Bool) -> Void
    typealias APIFailure = () -> Void
    typealias DiplayProgress = (_ progress: Any) -> Void
    typealias paramsJSON = [String:Any]
    typealias SwiftDict = Dictionary<String, Any>
    
    //MARK:-  Get and Post Request Function
    //MARK:-
    
    func getRequest(urlString: String, showLoader: Bool, _ onSuccess : @escaping (APISuccess), _ onFailure: APIFailure) {
        
        if showLoader {
            Loader.show()
        }
        
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (data, response, error) in
            if showLoader {
                DispatchQueue.main.async {
                    Loader.hide()
                }
            }
            if let error = error {
                DispatchQueue.main.async {
                    DisplayBanner.show(message: error.localizedDescription)
                }
            } else {
                do {
                    if let responseData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                        onSuccess(responseData, true)
                    }
                } catch let error as NSError {
                    DispatchQueue.main.async {
                        DisplayBanner.show(message: error.localizedDescription)
                    }
                }
            }
            }.resume()
    }
    
    func postRequest(urlString: String, params: paramsJSON, showLoader: Bool, _ onSuccess : @escaping (APISuccess), _ onFailure: APIFailure) {
        
        if showLoader {
            Loader.show()
        }
        
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = "POST"
        if params.keys.count > 0 {
            urlRequest.httpBody = convertDictToJSONData(params)
        }
        let session = URLSession(configuration: .ephemeral)
        session.dataTask(with: urlRequest) { (data, response, error) in
            if showLoader {
                DispatchQueue.main.async {
                    Loader.hide()
                }
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    DisplayBanner.show(message: error.localizedDescription)
                }
            } else {
                do {
                    if let responseData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] {
                        onSuccess(responseData, true)
                    }
                } catch let error as NSError {
                    DispatchQueue.main.async {
                        DisplayBanner.show(message: error.localizedDescription)
                    }
                }
            }
            }.resume()
    }
    
    //MARK:-  Get Header
    //MARK:-
    
//    func getURLRequestWithHeader(_ urlString: String) -> URLRequest {
//        var urlRequest = URLRequest(url: URL(string: urlString)!)
//        urlRequest.setValue("MOBILE", forHTTPHeaderField: "Channel")
//        urlRequest.setValue("iOS", forHTTPHeaderField: "User-Agent")
//        urlRequest.setValue("IPHONE", forHTTPHeaderField: "Device-Type")
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.setValue(K_CONSTANT_API_KEY, forHTTPHeaderField: "api-key")
//        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
//        urlRequest.setValue(db_Id, forHTTPHeaderField: "DB-Id")
//        urlRequest.setValue(DataManager.sharedManager.getDataFromKeyChain(key: "device_id"), forHTTPHeaderField: "device-id")
//        urlRequest.setValue(kSharedUserDefaults.getLoggedInUserId(), forHTTPHeaderField: "uid")
//        urlRequest.setValue(kSharedUserDefaults.getLoggedInUUId(), forHTTPHeaderField: "uuid")
//        urlRequest.setValue(K_COUPAN_BASE_URL, forHTTPHeaderField: "Referer")
//        return urlRequest
//    }
    
    func convertDictToJSONData(_ dict: [String: Any]) -> Data {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let dictFromJSON = decoded as? [String:String] {
                print(dictFromJSON)
            }
            return jsonData
        } catch {
            print(error.localizedDescription)
            return Data()
        }
    }
}


