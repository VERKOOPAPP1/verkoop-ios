//
//  InfoTextField.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 23/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit

class InfoTextField: UITextField {
    var enableImage = ""
    var disableImage = ""
    var shouldChangeIconState = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        font = UIFont.kAppDefaultFontBold(ofSize: 14.0)
        let placeHolderFont = UIFont.kAppDefaultFontRegular(ofSize: 14.0)
        setAttributedPlaceholderWith(font: placeHolderFont , color: UIColor.AppColor.appGray)
        borderStyle = .none
        borderForBottom()
        addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
    }
    
    @objc func textFieldTextChanged() {
        if text?.count ?? 0 > 1 {
            return
        }
        if text?.isEmpty ?? false {
            setBottomBorderColor(color: .gray)
            changeIconState(imageName: disableImage)
        } else {
            setBottomBorderColor(color: kAppDefaultColor)
            changeIconState(imageName: enableImage)
        }
    }
    
    func setBottomBorderColor(color: UIColor){
        let sublayers = layer.sublayers
        sublayers?.first?.borderColor = color.cgColor
    }
    
    func changeIconState(imageName: String) {
        if !shouldChangeIconState {
            return
        }
        if let imageView = leftView as? UIImageView {
            imageView.image = UIImage(named: imageName)
        }
    }
    
    func changeIcon(image: UIImage){
        if let imageView = leftView as? UIImageView {
            imageView.image = image
        }
    }
}
