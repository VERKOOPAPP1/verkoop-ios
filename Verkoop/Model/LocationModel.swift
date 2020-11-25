//
//  LocationModel.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

struct LocationModel  {
    var name: String?
    var formatted_address: String?
    var vicinity: String?
    var latitude: String?
    var longitude: String?
        
    init(dict: [String: Any?]) {
        if let name = dict["name"] as? String {
            self.name = name
        }

        if let address = dict["formatted_address"] as? String {
            self.formatted_address = address
        }

        if let vicinity = dict["vicinity"] as? String {
            self.vicinity = vicinity
        }

        if let geomatry = dict["geometry"] as? [String: Any], let location = geomatry["location"] as? [String: Any] {
            if let latitude = location["lat"] as? Double {
                self.latitude = String(format: "%f", latitude)
            }
            if let longitude = location["lng"] as? Double {
                self.longitude = String(format: "%f", longitude)
            }
        }
    }
}

struct StateModel {
    var id: Int!
    var name: String!
    var cities : [CityModel] = []
    
    init(json: [String:Any]) {
        id = Int.getInt(json["id"])                
        name = String.getString(json["name"])
        let cityList = Utilities.sharedUtilities.getArray(withDictionary: json["cities"])
        cities = cityList.map {
            let city = CityModel(json: Utilities.sharedUtilities.getDictionary($0))
            return city
        }
    }
}

struct CityModel {
    var id: Int!
    var name: String!
    
    init(json: Dictionary<String, Any>) {
        id = Int.getInt(json["id"])
        name = String.getString(json["name"])
    }
}

