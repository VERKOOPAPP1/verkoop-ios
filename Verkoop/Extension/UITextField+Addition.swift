//
//  UITextField+Custumization.swift
//  SmartMeetings
//
//  Created by MobileCoderz5 on 3/26/18.
//  Copyright © 2018 MobileCoderz5. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func borderForBottom() {
        let border = CALayer()
        let height = CGFloat(1.5)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - height, width:  self.frame.size.width, height: height)
        border.borderWidth = height
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
//    func setAttributedPlaceholder(hex: String) {
//        let attrs = [NSAttributedString.Key.font : UIFont.setFont(name: .semibold, size: FontSize.size17.rawValue),
//                     NSAttributedStringKey.foregroundColor : UIColor(hexString: hex)] as [NSAttributedString.Key : Any]
//        self.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: attrs)
//    }
    
    func setAttributedPlaceholderWith(font: UIFont, color: UIColor) {
        let attrs = [NSAttributedString.Key.font : font,
                     NSAttributedString.Key.foregroundColor : color] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: attrs)
    }
    
    func setRightView(imageName: String) {
        let imageView = UIImageView.init(frame: CGRect(x: 0,y:0,width: Int(self.frame.size.height/2),height: Int(self.frame.size.height/2)))
        let image = UIImage.init(named: imageName)
        imageView.image = image
        self.rightView = imageView
        imageView.contentMode = .scaleAspectFit
        self.rightViewMode = .always
    }
    
    func setLeftView(imageName: String) {
        let imageView = UIImageView.init(frame: CGRect(x: 0,y:0,width: Int(self.frame.size.height),height: Int(self.frame.size.height/2)))
        let image = UIImage.init(named: imageName)
        imageView.image = image
        self.leftView = imageView
        imageView.contentMode = .scaleAspectFit
        self.leftViewMode = .always
    }    
    
    func addLeftMargin() {
        let marginView = UIView(frame: CGRect(x: 0,y:0,width: 20,height: Int(self.frame.size.height/2)))
        self.leftView = marginView
        self.leftViewMode = .always
    }
    
    func setRightClickableView(normalImage: String, selectedImage: String){
        let button = UIButton.init(frame: CGRect(x: 0,y:0,width: Int(self.frame.size.height/2),height: Int(self.frame.size.height/2)))
        button.setImage(UIImage(named: normalImage), for: .normal)
        button.setImage(UIImage(named: selectedImage), for: .selected)
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        rightView = button
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        self.rightViewMode = .always
    }
    
    @objc func buttonTapped(sender: UIButton){
        sender.isSelected.toggle()
        self.isSecureTextEntry = !sender.isSelected
    }
    
    func setRightViewWith(imageName: String, frame: CGRect){
        let imageView = UIImageView.init(frame: frame)
        let image = UIImage.init(named: imageName)
        imageView.image = image
        self.rightView = imageView
        imageView.contentMode = .scaleAspectFit
        self.rightViewMode = .always
    }
    
    func applyPadding(padding: Int){
        let paddingView = UIView.init(frame: CGRect(x: 0,y:0,width: padding,height: Int(self.frame.size.height)))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setLeft(image: UIImage) {
        let imageView = UIImageView.init(frame: CGRect(x: 0,y:0,width: Int(self.frame.size.height),height: Int(self.frame.size.height/2)))
        imageView.image = image
        self.leftView = imageView
        imageView.contentMode = .scaleAspectFit
        self.leftViewMode = .always
    }
    
    func setLeftImage(imageName: String) {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 25, height: self.frame.size.height)
        let leftImage = UIImageView()
        containerView.addSubview(leftImage)
        leftImage.image = UIImage(named: imageName)
        leftImage.snp.makeConstraints { (make) in
            make.height.equalTo(12)
            make.width.equalTo(12)
            make.center.equalTo(containerView)
        }
        leftViewMode = .always
        leftView = containerView
    }
}

extension UITextView {
    
    @IBInspectable var doneAccessory: Bool {
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone {
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}

extension UITextField {
    @IBInspectable var doneAccessory: Bool {
        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone {
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}


