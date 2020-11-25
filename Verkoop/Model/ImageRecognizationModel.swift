//
//  ImageRecognizationModel.swift
//  Verkoop
//
//  Created by Vijay Singh Raghav on 03/09/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

struct ImageRecognizationModel: Codable {
    let responses: [ResponseArray?]
}

struct ResponseArray: Codable {
    let webDetection: WebDetection?
    let labelAnnotations: [DetailText]?
}

struct WebDetection: Codable {
    let webEntities: [DetailText]?
    let bestGuessLabels: [DetailText]?
}

struct DetailText: Codable {
    let label: String?
    let description: String?
}
