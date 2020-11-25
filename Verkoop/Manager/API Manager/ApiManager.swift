//
//  ApiManager.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import Alamofire

class ApiManager {

    enum HTTPMethodType {
        case post
        case get
        case put
        case delete
    }
    
    enum Result<T> {
        case success(T)
        case failure(Error?)
        case noDataFound(String)
    }
    
    class func request(isGoogleAPI: Bool = false ,path:String, parameters: [String:Any]?, methodType: HTTPMethodType, showLoader: Bool = true, result: @escaping (Result<Any>) -> ()) {
        let serviceUrlPathString = isGoogleAPI ? path : API.baseUrl + path
        var method: HTTPMethod = .post
        switch methodType {
        case .get:
            method = .get
        case .post:
            method = .post
        case .put:
            method = .put
        case .delete:
            method = .delete
        }
        
        if showLoader {
            Loader.show()
        }
        
        var headers = [String: String]()
        headers = ["Accept": "application/json", Bundle.main.bundleIdentifier ?? "" : "X-Ios-Bundle-Identifier"]
        if let token = Constants.sharedUserDefaults.value(forKey: ServerKeys.token) as? String {
            headers = [
                "Accept": "application/json",
                "Authorization": "Bearer \(token)",
                Bundle.main.bundleIdentifier ?? "" : "X-Ios-Bundle-Identifier"
            ]
        }        
        Alamofire.request(serviceUrlPathString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: isGoogleAPI ? [:] : headers).responseJSON { (response) in
            if showLoader && !isGoogleAPI {
                Loader.hide()
            }
            logRequest(response: response, parms: parameters)
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value, let code = response.response?.statusCode {
                    prettyPrint(json: data, statusCode: code)
                    ApiManager.handleSuccess(data: data, statusCode: code, result: { (res) in
                        switch(res) {
                        case .success(let data):
                            result(Result.success(data))
                        case .failure(let error):
                            result(Result.failure(error))
                        case .noDataFound(let message):
                            result(Result.noDataFound(message))
                        }
                    })
                } else {
                    Console.log(ErrorMessages.errorToHandleInSuccess)
                }
            case .failure(_):
                if let error = response.result.error  {
                    result(Result.failure(error))
                    Console.log("failure: \(error)")
                } else {
                    result(Result.failure(nil))
                    Console.log(ErrorMessages.errorToHandleInFailure)
                }
            }
        }
    }
    
    private class func handleSuccess(data: Any, statusCode: Int, result:(Result<Any>) -> ()) {
        if statusCode == StatusCode.success || statusCode == StatusCode.resourceCreated {
            result(Result.success(data))
        } else if statusCode == StatusCode.unauthorized {
            result(Result.failure(nil))
        } else {
            if let data = data as? [String : Any] {
                let errorModel = ResponseModel(response: data)
                if let message = errorModel.message {
                    DisplayBanner.show(message: message)
                    if statusCode == StatusCode.noDataFound {
                        result(Result.noDataFound(message))
                    }
                } else {
                    result(Result.failure(nil))
                }
            } else {
                result(Result.failure(nil))
            }
        }
    }
    
    class func prettyPrint(json: Any, statusCode: Int){
        Console.log("Status code is == \(statusCode)")
        if let json = json as? [String: Any] {
            Console.log(prettyPrintDict(with: json))
        } else if let json = json as? [Any] {
            Console.log(prettyPrintArray(with: json))
        }
    }
    
    private class func prettyPrintArray(with json: [Any]) -> String{
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let string = String(data: data, encoding: String.Encoding.utf8)
            if let string  = string {
                return string
            }
        } catch {
            Console.log(error.localizedDescription)
        }
        return ""
    }
    
    private class func prettyPrintDict(with json: [String : Any]) -> String{
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let string = String(data: data, encoding: String.Encoding.utf8)
            if let string  = string {
                return string
            }
        } catch {
            Console.log(error.localizedDescription)
        }
        return ""
    }
    
    private class func logRequest(response: DataResponse<Any>, parms: [String:Any]?) {
        if let url = response.request?.url{
            Console.log("URL: \(url)")
        }
        if let headerFields = response.request?.allHTTPHeaderFields {
            Console.log("HeaderFields:  \(headerFields)")
        }
        if let requestType = response.request?.httpMethod {
            Console.log("requestType:  \(requestType)")
        }
        if let parms = parms {
            Console.log("parms:  \(parms)")
        }
    }
    
    class func requestMultipartApiServer(path:String,parameters: [String:Any]?, methodType: HTTPMethodType, showLoader: Bool = true, result: @escaping (Result<Any>) -> () , _ onProgress: @escaping (Double)-> ()) {
        let serviceUrlPathString = API.baseUrl + path
        var method: HTTPMethod = .post
        switch methodType {
        case .get:
            method = .get
        case .post:
            method = .post
        case .put:
            method = .put
        case .delete:
            method = .delete
        }
        
        if showLoader {
            Loader.show()
        }
        
        var headers = [String: String]()
        headers = ["Accept": "application/json", Bundle.main.bundleIdentifier ?? "" : "X-Ios-Bundle-Identifier"]
        if let token = Constants.sharedUserDefaults.value(forKey: ServerKeys.token) as? String {
            headers = [
                "Accept": "application/json",
                "Authorization": "Bearer \(token)",
                Bundle.main.bundleIdentifier ?? "" : "X-Ios-Bundle-Identifier"
            ]
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters! {
                if key == ServerKeys.chatImage {
                    if let imageData = value as? Data {
                        multipartFormData.append(imageData, withName: key, fileName: "chat_image", mimeType: "image/jpeg")
                    }
                } else if key == ServerKeys.banner {
                    if let imageData = value as? Data {
                        multipartFormData.append(imageData, withName: key, fileName: "banner", mimeType: "image/jpeg")
                    }
                } else if key == ServerKeys.profile_pic {
                    if let imageData = value as? Data {
                        multipartFormData.append(imageData, withName: key, fileName: "profile_pic", mimeType: "image/jpeg")
                    }
                } else if key == ServerKeys.image {
                    if let imageDataArray = value as? [Data] {
                        for (index, data) in imageDataArray.enumerated() {
                            multipartFormData.append(data, withName: "\(key)[]", fileName: "images\(index)", mimeType: "image/jpeg")
                        }
                    }
                } else if key == AddDetailDictKeys.additional_info.rawValue {
                    multipartFormData.append(((value as Any) as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                } else if key == AddDetailDictKeys.label.rawValue {
                    if let labelArray = value as? [[String:String]] {
                        if let jsonData = try? JSONSerialization.data(withJSONObject: labelArray, options: [.prettyPrinted]) {
                            let jsonString = String(data: jsonData, encoding: .ascii)
                            let data = ((jsonString as Any) as AnyObject).data(using: String.Encoding.utf8.rawValue)!
                            multipartFormData.append(data, withName: key)
                        }
                    }
                } else {
                    if let tags = value as? [String] {
                        for tag in tags {
                            multipartFormData.append(((tag as Any) as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: "\(key)[]")
                            
                        }
                    } else {
                        multipartFormData.append(((value as Any) as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                }
            }
        } , usingThreshold: UInt64.init(), to: serviceUrlPathString, method: method, headers: headers, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    onProgress(Progress.fractionCompleted)
                })
                upload.responseJSON {
                    response in
                    logRequest(response: response, parms: parameters)
                    if showLoader {
                        Loader.hide()
                    }
                    switch(response.result) {
                    case .success(_):
                        if let data = response.result.value, let code = response.response?.statusCode {
                            prettyPrint(json: data, statusCode: code)
                            ApiManager.handleSuccess(data: data, statusCode: code, result: { (res) in
                                if code == StatusCode.unauthorized {
                                    Constants.sharedAppDelegate.logoutUser()
                                } else {
                                    switch(res) {
                                    case .success(let data):
                                        result(Result.success(data))
                                    case .failure(let error):
                                        result(Result.failure(error))
                                    case .noDataFound(let message):
                                        result(Result.noDataFound(message))
                                    }
                                }
                            })
                        } else {
                            Console.log(ErrorMessages.errorToHandleInSuccess)
                        }
                    case .failure(_):
                        if let error = response.result.error {
                            result(Result.failure(error))
                            Console.log("failure: \(error)")
                        } else {
                            result(Result.failure(nil))
                            Console.log(ErrorMessages.errorToHandleInFailure)
                        }
                    }
                }
            case .failure(let encodingError):
                Console.log(encodingError.localizedDescription)
                result(Result.failure(encodingError))
            }
        })
    }
    
    class func fetchData<T: Decodable>(apiQueue:DispatchQueue , urlString: String, completion: @escaping (T?) -> ()) {
        let url = URL(string: API.baseUrl + urlString)
        apiQueue.async {
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil)
                    return
                }
                guard let dataObject = data else {
                    completion(nil)
                    return
                }
                do {
                    let object = try JSONDecoder().decode(T.self, from: dataObject)
                    completion(object)
                } catch let parsingError {
                    print(parsingError.localizedDescription)
                }
            }).resume()
        }
    }
}
