//
//  AddDetailVC+Services.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 14/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

extension AddDetailVC  {
    func addItemService(params: [String: Any]?) {
        var endPoint = ""
        if isEdit {
            endPoint = MethodName.updateItem
        } else {
            endPoint = MethodName.addItem
        }
        ApiManager.requestMultipartApiServer(path: endPoint, parameters: params, methodType: .post, showLoader: true, result: { [weak self](result) in
            switch result {
            case .success(let data):
                if let item: Item = self?.handleSuccess(data: data), let imageURL = item.image {
                    self?.showpop(imageURl: imageURL)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
            DispatchQueue.main.async {
                Loader.hide()
            }
        }) { (progress) in
            Console.log(progress)
        }        
    }
    
    func getImageLabelFromVision(with base64Array: [String], completion: @escaping (_ status: Bool, _ result: [[String: String]])-> ()) {
        let methodName = API.googleURL
        var requestParam: [[String: Any]] = []
        for imageData in base64Array {
            let imageDetail: [String: Any] = [
                "image": [
                    "content": imageData
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 2
                    ],
                    [
                        "type": "WEB_DETECTION",
                        "maxResults": 2
                    ]
                ]
            ]
            requestParam.append(imageDetail)
        }
        let param = ["requests": requestParam]
        ApiManager.request(isGoogleAPI: true ,path:methodName, parameters: param, methodType: .post, showLoader: true) { [weak self](result) in
            switch result {
            case .success(let data):
                if let response: ImageRecognizationModel = self?.handleSuccess(data: data) {
                    var arrayOfLabel: [[String: String]] = []
                    for dataItems in response.responses {
                        var recognizedTag = ""
                        if let bestText = dataItems?.webDetection?.bestGuessLabels?.first , let text = bestText.label{
                            recognizedTag = text
                        }
                        if let webEntities = dataItems?.webDetection?.webEntities {
                            for entities in webEntities {
                                if let textString = entities.description {
                                    recognizedTag = recognizedTag + "," + textString
                                }
                            }
                        }
                        
                        if let labelAnotations = dataItems?.labelAnnotations {
                            for anotation in labelAnotations {
                                recognizedTag = recognizedTag + "," + (anotation.description ?? "")
                            }
                        }
                        arrayOfLabel.append(["text": recognizedTag])
                    }
                    completion(true, arrayOfLabel)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
                completion(false, [])
            case .noDataFound(_):
                completion(false, [])
                break
            }
            DispatchQueue.main.async {
                Loader.hide()
            }
        }
    }
    
    func showpop(imageURl: String) {
        if isEdit {
            didNavigateToProfileScreen()
        } else {
            let postAddVC = PostAddedVC.instantiate(fromAppStoryboard: .categories)
            postAddVC.modalPresentationStyle = .overCurrentContext
            postAddVC.modalTransitionStyle = .crossDissolve
            postAddVC.itemImage = API.assetsUrl + imageURl
            postAddVC.itemName = addDetailDict[AddDetailDictKeys.name.rawValue] as? String ?? ""
            postAddVC.categoryName = (addDetailDict[AddDetailDictKeys.parent_name.rawValue] as? String ?? "") + "->" + (addDetailDict[AddDetailDictKeys.category_name.rawValue] as? String ?? "")
            if itemType == .generic {
              postAddVC.price = addDetailDict[AddDetailDictKeys.price.rawValue] as? String ?? ""
            } else {
                postAddVC.price = String(format: "%@ - R%@", addDetailDict[AddDetailDictKeys.minPrice.rawValue] as! String, addDetailDict[AddDetailDictKeys.maxPrice.rawValue] as! String)
            }
            postAddVC.delegate = self
            navigationController?.present(postAddVC, animated: true, completion: nil)
        }
    }
}
