//
//  SignupVC+CountryPicker.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 28/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import CountryPickerView

extension SignupVC: CountryPickerViewDataSource, CountryPickerViewDelegate{
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        print(country)
        let countryCode = "\(country.name) ( \(country.code) )"
        textFieldCountry.text = countryCode
        textFieldCountry.changeIcon(image: country.flag)
    }
    
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        return []
    }
    
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
    
}
