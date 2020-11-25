//
//  Category.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 07/12/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import Foundation
//struct Category{
//    var category = [CategoryInfo]()
//    init() {
//        let a1 = CategoryInfo(name: "Womens", normalImageString: "women_unselected", selectedImageString: "women_selected")
//          let a2 = CategoryInfo(name: "Desktop", normalImageString: "desktop_unselected", selectedImageString: "desktop_selected")
//         let a3 = CategoryInfo(name: "Pets", normalImageString: "pet_unselected", selectedImageString: "pet_selected")
//         let a4 = CategoryInfo(name: "Mens", normalImageString: "men_unselected", selectedImageString: "men_selected")
//         let a5 = CategoryInfo(name: "Mobiles", normalImageString: "mobile_unselected", selectedImageString: "mobile_selected")
//         let a6 = CategoryInfo(name: "Car", normalImageString: "car_unselected", selectedImageString: "car_selected")
//         let a7 = CategoryInfo(name: "Footwear", normalImageString: "footwear_unselected", selectedImageString: "footwear_selected")
//         let a8 = CategoryInfo(name: "Furniture", normalImageString: "furniture_unselected", selectedImageString: "furniture_selected")
//         let a9 = CategoryInfo(name: "Books", normalImageString: "books_unselected", selectedImageString: "books_selected")
//        category.append(a1)
//        category.append(a2)
//        category.append(a3)
//        category.append(a4)
//        category.append(a5)
//        category.append(a6)
//        category.append(a7)
//        category.append(a8)
//        category.append(a9)
//
//        category.append(a1)
//        category.append(a2)
//        category.append(a3)
//        category.append(a4)
//        category.append(a5)
//        category.append(a6)
//        category.append(a7)
//        category.append(a8)
//        category.append(a9)
//
//        category.append(a1)
//        category.append(a2)
//        category.append(a3)
//        category.append(a4)
//        category.append(a5)
//        category.append(a6)
//        category.append(a7)
//        category.append(a8)
//        category.append(a9)
//
//        _ = ["Men's Fashion",
//         "Women's Fashion",
//         "Health & Beauty",
//         "Sports",
//         "Textbooks",
//         "Home & Furniture",
//         "Auto Accessories & Others",
//         "Kitchen & Appliances",
//         "Motorbikes",
//         "Babies & Kids",
//         "Music",
//         "J-Pop",
//         "Electronics",
//         "Tickets & Vouchers",
//         "Toys & Games",
//         "Cars",
//         "K-Wave",
//         "Books & Stationery",
//         "Photography",
//         "Community",
//         "Pets Supplies",
//         "Design & Craft",
//         "Property",
//         "Video Gaming",
//         "Everything Else",
//         "Antiques"]
//
//    }
//}
//struct CategoryInfo{
//    var isSelected = false
//    let name: String
//    let normalImageString: String
//    let selectedImageString: String
//    init(name: String, normalImageString: String, selectedImageString: String) {
//        self.name = name
//        self.normalImageString = normalImageString
//        self.selectedImageString = selectedImageString
//    }
//}

struct CategoryList: Codable {
    let message: String?
    var data: [Category]?
    let cars_type: [Category]?
}

struct Category: Codable {
    let sub_category: [SubCategory]?
    var car_models: [CarSeries]?
    let id: Int?
    let created_at: String?
    let updated_at: String?
    let name: String?
    let image: String?
    var isSelected: Bool?
}

struct CarSeries: Codable {
    let id: Int?
    let brand_id: Int?
    let is_active: Int?
    let created_at: String?
    let updated_at: String?
    let name: String?
    let image: String?
    var isSelected: Bool?
}

struct SubCategory: Codable {
    let id: Int?
    let name: String?
    let image: String?    
}

