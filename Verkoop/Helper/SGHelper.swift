//
//  SGHelper.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 31/01/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

//import UIKit
//import CoreLocation
//
//enum Themes : Int {
//    case black
//    case white
//}
//
//enum Language : Int {
//    case en
//    case ar
//}
//
//var myBundle:Bundle?
//var viewBackground:UIView?
//var mainNavigation:UINavigationController?
//var APP_DELEDATE = UIApplication.shared.delegate as! AppDelegate
//
//struct Constant {
//    // COLOR
//
//    static let kAPP_RED_COLOR               = UIColor.getRGBColor(255, g: 0, b: 59)
//    static let kCOLOR_STATUS_DISPATCH       = UIColor.getRGBColor(247, g: 163, b: 9)
//    static let kCOLOR_STATUS_DELIVERED      = UIColor.getRGBColor(0, g: 165, b: 64)
//    static let kCOLOR_STATUS_HOLD           = UIColor.getRGBColor(196, g: 81, b: 191)
//
//    static let APPNAME              = "Verkoop"
//    static let kMETHOD              = "method"
//    static let kAPPDELEGATE         = UIApplication.shared.delegate as! AppDelegate
//    static let animatioDuration     = 0.75
//    //static let kBASE_URL            = "https://quzyn.herokuapp.com/api/v1/user/"
//    static var kFbId                = ""
//
//
//}
//
////MARK: *************** Extension UIColor ***************
//extension UIColor{
//
//    var r: CGFloat{
//        return self.cgColor.components![0]
//    }
//
//    var g: CGFloat{
//        return self.cgColor.components![1]
//    }
//
//    var b: CGFloat{
//        return self.cgColor.components![2]
//    }
//
//    var alpha: CGFloat{
//        return self.cgColor.components![3]
//    }
//}
//
//
//extension UIImageView {
//    public func imageFromServerURL(urlString: String) {
//        self.image = UIImage(named: "user")
//        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
//            if let error  = error {
//                print(error.localizedDescription)
//                return
//            }
//            DispatchQueue.main.async(execute: { () -> Void in
//                let image = UIImage(data: data!)
//                self.image = image
//            })
//
//        }).resume()
//    }}
//
////MARK: *************** Extension UITabBar ***************
//extension UITabBar {
//
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        super.sizeThatFits(size)
//        var sizeThatFits = super.sizeThatFits(size)
//        if UI_USER_INTERFACE_IDIOM() == .pad{
//            sizeThatFits.height = 100
//        }
//        return sizeThatFits
//    }
//}
//
////MARK: *************** Extension UIViewController ***************
//extension UIViewController
//{
//
//    func showDescriptionInAlert(_ desc:String,title:String,animationTime:Double,descFont:UIFont) {
//        viewBackground?.removeFromSuperview()
//        viewBackground = UIView(frame: UIScreen.main.bounds)
//        let viewAlertContainer = UIView()
//        let txtViewDesc = UITextView()
//        viewAlertContainer.backgroundColor = UIColor.white
//        viewBackground!.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//        txtViewDesc.backgroundColor = UIColor.white
//        viewBackground!.alpha = 0.0
//        txtViewDesc.text = desc
//        txtViewDesc.isEditable = false
//        txtViewDesc.font = descFont
//        viewAlertContainer.makeRoundCorner(10)
//        txtViewDesc.textAlignment = .center
//        var txtViewHeight = CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width-80, height: 100)
//        let height = heightForLabel(desc, width: UIScreen.main.bounds.width-80, font: descFont)
//        if height > 80 && height < 300 {
//            txtViewHeight.size.height = height+20
//        }
//        let lblTitle = UILabel(frame: CGRect(x: 0, y: 8, width: UIScreen.main.bounds.width-80, height: 20))
//        lblTitle.text = title
//        lblTitle.textColor = UIColor.black
//        lblTitle.font = UIFont.systemFont(ofSize: 18)
//        lblTitle.backgroundColor = UIColor.white
//        lblTitle.textAlignment = .center
//        txtViewDesc.frame = txtViewHeight
//        viewAlertContainer.frame = CGRect(x: 40, y: 100, width: UIScreen.main.bounds.width-80, height: txtViewHeight.size.height+30)
//        viewAlertContainer.center = viewBackground!.center
//        viewAlertContainer.addSubview(lblTitle)
//        viewAlertContainer.addSubview(txtViewDesc)
//        viewBackground!.addSubview(viewAlertContainer)
//        self.view.addSubview(viewBackground!)
//        UIView.animate(withDuration: animationTime) {
//            viewBackground!.alpha = 1.0
//        }
//    }
//
//    func hideDescriptionAlert(_ animationTime:Double) {
//        UIView.animate(withDuration: animationTime, animations: {
//            viewBackground?.alpha = 0.0
//        }) { (compelete) in
//            if compelete {
//                viewBackground?.removeFromSuperview()
//            }
//        }
//    }
//
//    func showOkAlert(_ msg: String) {
//        let alert = UIAlertController(title:
//            Constant.APPNAME, message: msg, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(okAction)
////        alert.view.tintColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1)
//
//        present(alert, animated: true, completion: nil)
//    }
//
//    func showOkAlertWithHandler(_ msg: String,handler: @escaping ()->Void){
//        let alert = UIAlertController(title: Constant.APPNAME, message: msg, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "Ok", style: .default) { (type) -> Void in
//            handler()
//        }
//        alert.view.tintColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1)
//        alert.addAction(okAction)
//        present(alert, animated: true, completion: nil)
//    }
//
//    func showAlertWithActions(msg: String,titles:[String], handler:@escaping (_ clickedIndex: Int) -> Void) {
//
//
//        if titles.last?.lowercased() == "cancel" {
//            let alert = UIAlertController(title: Constant.APPNAME, message: msg, preferredStyle: .actionSheet)
//            for title in titles {
//                if title.lowercased() == "cancel" {
//                    let action  = UIAlertAction(title: title, style: .cancel, handler: { (alertAction) in
//                        //fall the Call when user clicked
//                        let index = titles.index(of: alertAction.title!)
//                        if index != nil {
//                            handler(index!+1)
//                        }
//                        else {
//                            handler(0)
//                        }
//                    })
//                    alert.addAction(action)
//                } else {
//                    let action  = UIAlertAction(title: title, style: .default, handler: { (alertAction) in
//                        //fall the Call when user clicked
//                        let index = titles.index(of: alertAction.title!)
//                        if index != nil {
//                            handler(index!+1)
//                        }
//                        else {
//                            handler(0)
//                        }
//                    })
//                    alert.addAction(action)
//                }
//            }
//            present(alert, animated: true, completion: nil)
//        }
//        else {
//            let alert = UIAlertController(title: Constant.APPNAME, message: msg, preferredStyle: .alert)
//
//            for title in titles {
//
//                let action  = UIAlertAction(title: title, style: .default, handler: { (alertAction) in
//                    //Call back fall when user clicked
//                    let index = titles.index(of: alertAction.title!)
//                    if index != nil {
//                        handler(index!+1)
//                    }
//                    else {
//                        handler(0)
//                    }
//
//                })
//                alert.addAction(action)
//            }
//            present(alert, animated: true, completion: nil)
//        }
//    }
//
//    func showOkCancelAlertWithAction(_ msg: String, handler:@escaping (_ isOkAction: Bool) -> Void) {
//        let alert = UIAlertController(title: Constant.APPNAME, message: msg, preferredStyle: .alert)
//        let okAction =  UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
//            return handler(true)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
//            return handler(false)
//        }
//        let attributedText = NSAttributedString(string: msg, attributes: [.font: UIFont.systemFont(ofSize: 18), .foregroundColor:  UIColor.black])
//        alert.setValue(attributedText, forKey: "attributedMessage")
//
//        alert.view.tintColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1)
//        alert.addAction(cancelAction)
//        alert.addAction(okAction)
//        present(alert, animated: true, completion: nil)
//    }
//
//
//    /// Adds a custom back button
//    func addBackButton() {
//        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        let backImage = UIImage(named: "back")
//        backButton.setImage(backImage, for: .normal)
//        backButton.addTarget(self, action: #selector(goBack(_:)), for: .touchUpInside)
//        let backBarButton = UIBarButtonItem(customView: backButton)
//        self.navigationItem.leftBarButtonItem = backBarButton
//    }
//
//
//
//    @objc func goBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//}
//
////MARK: *************** Extension NSDate ***************
//extension Date{
//    func convertToString(_ validDateFormatter:String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = validDateFormatter //"dd MMM yyyy" //yyyy-mm-dd hh:mm
//        return dateFormatter.string(from: self as Date)
//
//    }
//        var age: Int {
//            return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
//        }
//
//    func dayOfWeek() -> String? {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "EEEE"
//            return dateFormatter.string(from: self).capitalized
//        }
//
//    func yearsFrom(date:Date) -> Int{
//        return Calendar.current.dateComponents([.year], from: date, to: self).year!
//    }
//    func monthsFrom(date:Date) -> Int{
//        return Calendar.current.dateComponents([.month], from: date as Date, to: self).month!
//    }
//    func weeksFrom(date:Date) -> Int{
//        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear!
//    }
//    func daysFrom(date:Date) -> Int{
//        return Calendar.current.dateComponents([.day], from: date, to: self).day!
//    }
//    func hoursFrom(date:Date) -> Int{
//        return Calendar.current.dateComponents([.hour], from: date, to: self).hour!
//    }
//    func minutesFrom(date:Date) -> Int{
//        return Calendar.current.dateComponents([.minute], from: date, to: self).minute!
//    }
//    func secondsFrom(date:Date) -> Int{
//        return Calendar.current.dateComponents([.second], from: date, to: self).second!
//    }
//
//    func offsetFrom(date:Date) -> String {
//        if yearsFrom(date: date) > 0 {
//            return "\(yearsFrom(date: date))y"
//        }
//        if monthsFrom(date: date) > 0 {
//            return "\(monthsFrom(date: date))M"
//        }
//        if weeksFrom(date: date) > 0{
//            return "\(weeksFrom(date: date))w"
//        }
//        if daysFrom(date: date) > 0 {
//            return "\(daysFrom(date: date))d"
//        }
//        if hoursFrom(date: date) > 0 {
//            return "\(hoursFrom(date: date))h"
//        }
//        if minutesFrom(date: date) > 0 {
//            return "\(minutesFrom(date: date))m"
//        }
//        if secondsFrom(date: date) > 0 {
//            return "\(secondsFrom(date: date))s"
//        }
//        return ""
//    }
//}
//
////MARK: *************** Extension CLLocation ***************
//
//extension CLLocation{
//    func getCityName(_ City:@escaping (_ city:String)->Void){
//        let geoCoder = CLGeocoder()
//        geoCoder.reverseGeocodeLocation(self, completionHandler: { (placemarks, error) -> Void in
//
//            // Place details
//            var placeMark: CLPlacemark!
//            placeMark = placemarks?[0]
//
//            // Address dictionary
//            print(placeMark.addressDictionary ?? "")
//
//            // Location name
//            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
//                print(locationName)
//            }
//
//            // Street address
//            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
//                print(street)
//            }
//
//            // City
//            if let city = placeMark.addressDictionary!["City"] as? NSString {
//                City(city as String)
//                print(city)
//            }
//
//            // Zip code
//            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
//                print(zip)
//            }
//
//            // Country
//            if let country = placeMark.addressDictionary!["Country"] as? NSString {
//                print(country)
//            }
//        })
//    }
//    func getAddress(_ Address:@escaping (_ address:String)->Void){
//
//        let geoCoder = CLGeocoder()
//
//        geoCoder.reverseGeocodeLocation(self, completionHandler: { (placemarks, error) -> Void in
//
//            // Place details
//            guard let placeMark = placemarks?[0] else {
//                return
//            }
//
//            // Address dictionary
//            guard let _ = placeMark.addressDictionary else {
//                return
//            }
//
//            if let formattedAddress = placeMark.addressDictionary!["FormattedAddressLines"] as? [String] {
//                Address(formattedAddress.joined(separator: ", "))
//            }
//        })
//    }
//
//
//}
//
//
////MARK: *************** Extension String ***************
//
//extension String {
//
//    func getDateInstance(validFormate:String)-> Date? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = validFormate
//        return dateFormatter.date(from:self)
//    }
//
//    func UTCToLocal(validFormate:String) -> Date?  {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = validFormate
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//
//        let dt = dateFormatter.date(from: self)
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.dateFormat = validFormate
//
//        return dt
//    }
//
//    func hasSpecialCharacter() -> Bool {
//        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
//        if self.rangeOfCharacter(from: characterset.inverted) != nil {
//            return true
//        }
//        return false
//    }
//
//
//
//    var isNumber : Bool {
//        get{
//            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
//        }
//    }
//
//    func trim() -> String {
//        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//    }
//
//    var isContainAnyNumber : Bool{
//        let decimalCharacters = CharacterSet.decimalDigits
//        let decimalRange = self.rangeOfCharacter(from: decimalCharacters)
//        if decimalRange != nil {
//            return true
//        }
//        else{
//            return false
//        }
//    }
//
//    var isContainAnyAlfabits : Bool {
//        let str1 = self
//        let str2 = self
//        let capitalizedLetters = CharacterSet.capitalizedLetters
//        let lowercaseLetters   = CharacterSet.lowercaseLetters
//        let capitalRange = str1.rangeOfCharacter(from: capitalizedLetters)
//        let lowerRange = str2.rangeOfCharacter(from: lowercaseLetters)
//
//        if capitalRange != nil{
//            return true
//        }
//        else if  lowerRange != nil{
//            return true
//        }
//        else{
//            return false
//        }
//    }
//
//
//    func fromBase64() -> String?{
//        let sDecode = self.removingPercentEncoding
//        return sDecode
//    }
//
//    func toDouble() -> Double? {
//        return NumberFormatter().number(from: self)?.doubleValue
//    }
//
//}
//
////MARK: *************** Extension UIView ***************
//extension UIView
//{
//
//    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        self.layer.mask = mask
//    }
//
//    func close(animate: Bool = true, duration: Double = 0.5) {
//        if !animate {
//            self.alpha = 0.0
//            return
//        }
//        UIView.animate(withDuration: duration, animations: {
//            self.alpha = 0.0
//        }) { (compelete) in
//            if compelete {
//                self.removeFromSuperview()
//            }
//        }
//    }
//
//    class func fromNib<T : UIView>(xibName: String) -> T {
//        return Bundle.main.loadNibNamed(xibName, owner: nil, options: nil )![0] as! T
//    }
//
//    func typeName(_ some: Any) -> String {
//        return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
//    }
//
//
//    //give the border to UIView
//    func border(radius : CGFloat,borderWidth : CGFloat,color :CGColor){
//        self.layer.masksToBounds = true
//        self.layer.cornerRadius  = radius
//        self.layer.borderWidth   = borderWidth
//        self.layer.borderColor   = color
//    }
//
//    //give the circle border to UIView
//    func circleBorder(){
//        let hight = self.layer.frame.height
//        let width = self.layer.frame.width
//        if hight < width{
//            self.layer.cornerRadius = hight/2
//            self.layer.masksToBounds = true
//        }
//        else{
//            self.layer.cornerRadius  = width/2
//            self.layer.masksToBounds = true
//        }
//    }
//    func addShadowFourSide() {
//        let shadowSize : CGFloat = 5.0
//        _ = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
//                                      y: -shadowSize / 2,
//                                      width: self.frame.size.width + shadowSize,
//                                      height: self.frame.size.height + shadowSize))
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        self.layer.shadowOpacity = 0.5
//    }
//
//    func snapshot() -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
//        self.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let img = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return img!
//    }
//
//
//    func addShadowWithRadius(radius: CGFloat ,cornerRadius: CGFloat ){
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//        layer.shadowOpacity = 0.5
//        layer.shadowRadius = radius
//        layer.cornerRadius = cornerRadius
//    }
//
//    func addShadowView() {
//        //Remove previous shadow views
//        superview?.viewWithTag(119900)?.removeFromSuperview()
//
//        //Create new shadow view with frame
//        let shadowView = UIView(frame: frame)
//        shadowView.tag = 119900
//        shadowView.layer.shadowColor = UIColor.black.cgColor
//        shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
//        shadowView.layer.masksToBounds = false
//        shadowView.layer.cornerRadius = 10
//        shadowView.layer.shadowOpacity = 0.3
//        shadowView.layer.shadowRadius = 3
//        shadowView.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
//        shadowView.layer.rasterizationScale = UIScreen.main.scale
//        shadowView.layer.shouldRasterize = true
//
//        superview?.insertSubview(shadowView, belowSubview: self)
//    }
//    func makeRoundCorner(){
//        self.layer.cornerRadius = self.frame.height/2
//        self.clipsToBounds = true
//    }
//}
//
//
////MARK: *************** Global Helper Method ***************
//func setLanguage(_ lang:String){
//    let path    =   Bundle.main.path(forResource: lang, ofType: "lproj")
//    if path == nil{
//        myBundle  = Bundle.main
//    }
//    else{
//        myBundle = Bundle(path:path!)
//        if (myBundle == nil) {
//            myBundle = Bundle.main
//        }
//    }
//}
//
//func setUserDefault(_ key:String,value:String){
//    print_debug(value)
//    print_debug(key)
//    let defaults = UserDefaults.standard
//    defaults.setValue(value, forKey: key)
//}
//
//func getUserDefault(_ key:String) -> Any? {
//    let defaults = UserDefaults.standard
//    if let val = defaults.value(forKey: key) {
//        return val
//    }
//    return nil
//}
//
//func removeUserDefault(_ key:String){
//    let defaults = UserDefaults.standard
//    defaults.removeObject(forKey: key)
//}
//
//func setDictUserDefault(_ detail:Dictionary<String,Any>){
//    for (key,value) in detail{
//        if(detail[key] != nil){
//            print_debug("\(key)")
//            setUserDefault(key, value: "\(value)")
//        }
//    }
//}
//
//func heightForLabel(_ text:String,width:CGFloat,font:UIFont) -> CGFloat{
//    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
//    label.numberOfLines = 0
//    label.lineBreakMode = NSLineBreakMode.byWordWrapping
//    label.font = font
//    label.text = text
//    label.sizeToFit()
//    return label.frame.height
//}
//
//func print_debug<T>(_ obj:T,file: String = #file, line: Int = #line, function: String = #function) {
//    print("File:'\(file.description)' Line:'\(line)' Function:'\(function)' ::\(obj)")
//}
//
//func uniq<S: Sequence, E: Hashable>(_ source: S) -> [E] where E==S.Iterator.Element {
//    var seen: [E:Bool] = [:]
//    return source.filter { seen.updateValue(true, forKey: $0) == nil }
//}
//
////MARK: *************** Helper Class ***************
//
//class SGHelper: NSObject {
//    static let viewLogo = UIView()
//
//    struct Platform {
//        static var isSimulator: Bool {
//            return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
//            //return TARGET_IPHONE_SIMULATOR != 0 // Use this line in Xcode 6
//        }
//    }
//
//
//    class func getCountryCallingCode(countryRegionCode:String = "")-> String {
//        guard let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String else {
//            return ""
//        }
//
//        let prefixCodes = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
//
//
//        let countryDialingCode = prefixCodes[countryCode]
//        return countryDialingCode!
//
//    }
//
//    class func isValidEmail(_ testStr:String) -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailTest.evaluate(with: testStr)
//    }
//
//    class func getDictionary(_ detail: Any?) -> Dictionary<String, Any>
//    {
//        guard let dict = detail as? Dictionary<String, Any> else
//        {
//            return ["":"" as Any]
//        }
//        return dict
//    }
//    class func convertArrayToString(arr:Array<Any>)->String{
//        var retStr = ""
//        for str in arr{
//            if retStr != ""{
//                retStr = "\(retStr),\(str)"
//            }
//            else{
//                retStr = "\(str)"
//            }
//        }
//
//        return retStr
//    }
//
//    //MARK: Find out address from alt long
//    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String, address : @escaping (String) -> Void) {
//        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//        let lat: Double = Double("\(pdblLatitude)")!
//        //21.228124
//        let lon: Double = Double("\(pdblLongitude)")!
//        //72.833770
//        let ceo: CLGeocoder = CLGeocoder()
//        center.latitude = lat
//        center.longitude = lon
//
//        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//
//
//        ceo.reverseGeocodeLocation(loc, completionHandler:
//            {(placemarks, error) in
//                if (error != nil)
//                {
//                    print("reverse geodcode fail: \(error!.localizedDescription)")
//                }
//                if placemarks == nil{
//                    print("************ placemarks is nil **********")
//                    return
//                }
//                let pm = placemarks! as [CLPlacemark]
//
//                if pm.count > 0 {
//                    let pm = placemarks![0]
//                    print(pm.country)
//                    print(pm.locality)
//                    print(pm.subLocality)
//                    print(pm.thoroughfare)
//                    print(pm.postalCode)
//                    print(pm.subThoroughfare)
//                    var addressString : String = ""
//                    if pm.subLocality != nil {
//                        addressString = addressString + pm.subLocality! + ", "
//                    }
//                    if pm.thoroughfare != nil {
//                        addressString = addressString + pm.thoroughfare! + ", "
//                    }
//                    if pm.locality != nil {
//                        addressString = addressString + pm.locality! + ", "
//                    }
//                    if pm.country != nil {
//                        //addressString = addressString + pm.country! + ", "
//                    }
//                    if pm.postalCode != nil {
//                        //addressString = addressString + pm.postalCode! + " "
//                    }
//                    address(addressString)
//                }
//        })
//    }
//    // Write text on Image
//}
//
////MARK: ************* Extension UIDatePicker *************
//
//extension UIDatePicker {
//    /// Returns the date that reflects the displayed date clamped to the `minuteInterval` of the picker.
//    /// - note: Adapted from [ima747's](http://stackoverflow.com/users/463183/ima747) answer on [Stack Overflow](http://stackoverflow.com/questions/7504060/uidatepicker-with-15m-interval-but-always-exact-time-as-return-value/42263214#42263214})
//    public var clampedDate: Date {
//        let referenceTimeInterval = self.date.timeIntervalSinceReferenceDate
//        let remainingSeconds = referenceTimeInterval.truncatingRemainder(dividingBy: TimeInterval(minuteInterval*60))
//        let timeRoundedToInterval = referenceTimeInterval - remainingSeconds
//        return Date(timeIntervalSinceReferenceDate: timeRoundedToInterval)
//    }
//}


//extension UITextField{
//    @IBInspectable var placeHolderColor: UIColor? {
//        get {
//            return self.placeHolderColor
//        }
//        set {
//            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
//        }
//    }
//}


