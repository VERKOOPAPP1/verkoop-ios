//
//  AddSelectCategoryModel.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 05/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit


struct AddSelectCategory {
    var sectionAddSelectArray = [SectionForAddCategory]()
    init() {
        
        //MARK:- Section1 For Sort
        var section1 = [RowsAddSelectCategory]()
        let row1 =  ["Health & Beauty","Man's Fashion","Woman's Fashion","Books","Luxury","Electronics","Photography"]
        for str in row1 {
            let row = RowsAddSelectCategory(filterCategory: str)
            section1.append(row)
        }
        let a1 = SectionForAddCategory(section: "Health & Beauty",arrayRow: section1)
        
        //MARK:- Section2 For Item Condition
        var section2 = [RowsAddSelectCategory]()
        let row2 =  ["Testing","Demo","Demo2"]
        for str in row2 {
            let row = RowsAddSelectCategory(filterCategory: str)
            section2.append(row)
        }
        let a2 = SectionForAddCategory(section: "Man's Fashion",arrayRow: section2)
        
        //MARK:- Section3 For Deal Option
        var section3 = [RowsAddSelectCategory]()
        let row3 =  ["Meat-up","Mailing & Delivery"]
        for str in row3 {
            let row = RowsAddSelectCategory(filterCategory: str)
            section3.append(row)
        }
        let a3 = SectionForAddCategory(section: "Woman's Fashion",arrayRow: section3)
        
        //MARK:- Section4 For Price
        var section4 = [RowsAddSelectCategory]()
        let row4 =  ["Testing","Demo","Demo2"]
        for str in row4 {
            let row = RowsAddSelectCategory(filterCategory: str)
            section4.append(row)
        }
        let a4 = SectionForAddCategory(section: "Books",arrayRow: section4)
        
        var section5 = [RowsAddSelectCategory]()
        let row5 =  ["Testing","Demo","Demo2"]
        for str in row5 {
            let row = RowsAddSelectCategory(filterCategory: str)
            section5.append(row)
        }
        let a5 = SectionForAddCategory(section: "Luxury",arrayRow: section5)
        
        
        var section6 = [RowsAddSelectCategory]()
        let row6 =  ["Testing","Demo","Demo2"]
        for str in row6 {
            let row = RowsAddSelectCategory(filterCategory: str)
            section6.append(row)
        }
        let a6 = SectionForAddCategory(section: "Electronics",arrayRow: section6)
        
        var section7 = [RowsAddSelectCategory]()
        let row7 =  ["Testing","Demo","Demo2"]
        for str in row7 {
            let row = RowsAddSelectCategory(filterCategory: str)
            section7.append(row)
        }
        let a7 = SectionForAddCategory(section: "Photography",arrayRow: section7)
        sectionAddSelectArray.append(a1)
        sectionAddSelectArray.append(a2)
        sectionAddSelectArray.append(a3)
        sectionAddSelectArray.append(a4)
        sectionAddSelectArray.append(a5)
        sectionAddSelectArray.append(a6)
        sectionAddSelectArray.append(a7)
    }
}

struct SectionForAddCategory {
    var section:String?
    var filterArray = [RowsAddSelectCategory]()
    var selectedIndexPath:IndexPath?
    init(section:String,arrayRow:[RowsAddSelectCategory]) {
        self.section = section
        self.filterArray = arrayRow
    }
}

struct RowsAddSelectCategory {
    let filterCategory : String
    var isSelected = false
    init(filterCategory : String) {
        self.filterCategory = filterCategory
    }
    
}



