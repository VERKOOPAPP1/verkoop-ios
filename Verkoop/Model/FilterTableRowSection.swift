//
//  FilterTableRowSection.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 04/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

struct Section {
    var sectionArray = [SectionForTable]()
    init() {
        
        var firstSection: [RowsForSection] = []
        let row1 =  ["Nearby","Popular","Recently added","Price : High to Low","Price : Low to High"]
        firstSection = row1.map {
            return RowsForSection(filterStr: $0)
        }
        
        let section1 = SectionForTable(section: "Sort",arrayRow: firstSection)
        
        var secondSection:  [RowsForSection] = []
        let row2 =  ["N.A"]
        secondSection = row2.map {
            return RowsForSection(filterStr: $0)
        }
        let section2 = SectionForTable(section: "Item Condition",arrayRow: secondSection)
        
        var thirdSection: [RowsForSection] = []
        let row3 =  ["Meet-up"]
        thirdSection = row3.map {
            return RowsForSection(filterStr: $0)
        }
        let section3 = SectionForTable(section: "Deal Option",arrayRow: thirdSection)
        
        var fourthSection: [RowsForSection] = []
        let row4 =  ["N.A"]
        fourthSection = row4.map {
            return RowsForSection(filterStr: $0)
        }
        let section4 = SectionForTable(section: "Price",arrayRow: fourthSection)
        
        sectionArray.append(section1)
        sectionArray.append(section2)
        sectionArray.append(section3)
        sectionArray.append(section4)
    }
}

struct SectionForTable {
    var section:String?
    var filterArray = [RowsForSection]()
    var selectedIndexPath:IndexPath?
    
    init(section:String,arrayRow:[RowsForSection]) {
        self.section = section
        self.filterArray = arrayRow
    }
}

struct RowsForSection {
    let filterStr:String
    var isSelected = false
    
    init(filterStr: String) {
        self.filterStr = filterStr
    }
}

enum FilterType : Int {
    case sort
    case itemType
    case meetUp
    case price
}

struct AppliedFilter {
    var filterName = ""
    var filterType: FilterType = .sort
    
    init(filterName: String, filterType: FilterType) {
        self.filterName = filterName
        self.filterType = filterType
    }
}


