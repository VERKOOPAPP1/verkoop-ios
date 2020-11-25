//
//  SelectLocation+Services.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 14/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension SelectMeetupLocationVC {
    func getNearBylocation(latLong: String) {
        let radius = "500"
        let endPoint = String(format: MethodName.nearByPlacesAPI, latLong, radius, API.placeAPIKey)
        ApiManager.request(isGoogleAPI: true, path:endPoint, parameters: nil, methodType: .get) { [weak self](result) in
            switch result {
            case .success(let data):
                self?.handleSuccess(data: data)
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func getSearchedLocation(searchString: String) {
        let endPoint = String(format: MethodName.searchAPI, searchString, API.placeAPIKey)
        ApiManager.request(isGoogleAPI: true, path:endPoint, parameters: nil, methodType: .get) { [weak self](result) in
            switch result {
            case .success(let data):
                self?.handleSuccess(data: data)
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
    
    func handleSuccess(data: Any) {
        if let response = data as? [String : Any] {
            let resultArray = Utilities.sharedUtilities.getArray(withDictionary: response["results"])
            if resultArray.count > 0 {
                locationArray = resultArray.map {
                    let location = LocationModel(dict: $0)                    
                    return location
                }
                searchField.text = ""
                tableView.reloadData()
            } else {
                DisplayBanner.show(message: ErrorMessages.somethingWentWrong)
            }
        } else {
            DisplayBanner.show(message: ErrorMessages.somethingWentWrong)
        }
    }
}
