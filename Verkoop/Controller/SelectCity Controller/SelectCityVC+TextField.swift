
import Foundation

extension SelectCityVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if selectionType == .regionSelection {
                if updatedText.isEmpty {
                    if isStateList {
                        searchedStateArray = stateArray
                    } else {
                        searchedCityArray = cityArray
                    }
                } else {
                    if isStateList {
                        searchedStateArray = stateArray.filter {
                            $0.name.range(of: updatedText, options: [.diacriticInsensitive, .caseInsensitive]) != nil
                        }
                    } else {
                        searchedCityArray = cityArray.filter {
                            $0.name.range(of: updatedText, options: [.diacriticInsensitive, .caseInsensitive]) != nil
                        }
                    }
                }
            } else if selectionType == .brandSelection {
                if updatedText.isEmpty {
                    if isBrandList {
                        searchedCategoryList = categoryList
                    } else {
                        searchedCategoryList = categoryList
                    }
                } else {
                    if isBrandList {
                        if let data = categoryList?.data, data.count > 0 {
                            searchedCategoryList?.data = categoryList?.data!.filter {
                                $0.name!.range(of: updatedText, options: [.diacriticInsensitive, .caseInsensitive]) != nil
                            }
                        }
                    } else {
                        if let data = categoryList?.data, data.count > 0 {
                            searchedCategoryList?.data![mainCategorySelectedIndex].car_models = categoryList?.data![mainCategorySelectedIndex].car_models!.filter {
                                $0.name!.range(of: updatedText, options: [.diacriticInsensitive, .caseInsensitive]) != nil
                            }
                        }
                    }
                }
            } else {
                
            }
            
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


