//
//  Utilities.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import FacebookShare

class Utilities {
    static let sharedUtilities = Utilities()
    func getArray(withDictionary array: Any?) -> [Dictionary<String, Any>] {
        guard let arr = array as? [Dictionary<String, Any>] else {
            return []
        }
        return arr
    }
    
    func getNextDate(dateString: String, day: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let createdDate = formatter.date(from: dateString), let tomorrow = Calendar.current.date(byAdding: .day, value: day, to: createdDate) {
            let formattedDate = DateFormatter()
            formattedDate.dateFormat = "dd MMMM yyyy"
            return formattedDate.string(from: tomorrow)
        }
        return "N.A"
    }
    
    func getDictionary(_ dictData: Any?) -> Dictionary<String, Any> {
        guard let dict = dictData as? Dictionary<String, Any> else {
            guard let arr = dictData as? [Any] else {
                return [:]
            }
            return getDictionary(arr.count > 0 ? arr[0] : ["":""])
        }
        return dict
    }
    
    func getFormattedData(dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let formattedDate = DateFormatter()
        formattedDate.dateFormat = "dd MMM yyyy"
        return formattedDate.string(from: formatter.date(from: dateString) ?? Date())
    }
    
    func getTimeDifference(dateString: String, isFullFormat: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        if isFullFormat {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        } else {
            formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        }
        let startDate = formatter.date(from: dateString)
        let endDate = Date()
        let indian = Calendar(identifier: .indian)
        let components =  indian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startDate ?? Date(), to: endDate)
        let years = components.year
        let months = components.month
        let days = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        if years == 0 {
            if months == 0 {
                if days == 0 {
                    if hour == 0 {
                        if minute == 0 {
                            return "\(String.getString(second)) Seconds ago"
                        } else {
                            return "\(String.getString(minute)) Minutes ago"
                        }
                    } else {
                        return "\(String.getString(hour)) Hours ago"
                    }
                } else {
                    return "\(String.getString(days))" + (days == 1 ? " Day ago" : " Days ago")
                }
            } else {
                return "\(String.getString(months))" + (months == 1 ? " Month ago" : " Months ago")
            }
        } else {
            return "\(String.getString(years))" + (years == 1 ? " Year ago" : " Years ago")
        }
    }
    
    class func shareOnWhatsApp(_ url: String) -> Bool {
        if let whatsappURL = URL(string: "whatsapp://send?text=\(url)"){
            if UIApplication.shared.canOpenURL(whatsappURL) {
                UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    class func share(content:String, controller:UIViewController, subjectLine:String) {
        let activityViewController = UIActivityViewController(activityItems: [content], applicationActivities: [])
        activityViewController.popoverPresentationController?.sourceView = controller.view
        activityViewController.setValue(subjectLine, forKey: "subject")
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        controller.present(activityViewController, animated: true)
    }
    
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = image.pngData()
        if (imagedata?.count ?? 0 > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 500, height: oldSize.height / oldSize.width * 500)
            imagedata = resizeImage(newSize, image: image)            
        }
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = newImage!.pngData()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    class func shareOnFacebook(shareURl: String, controller: UIViewController) -> Bool {
        
//        guard let url = URL(string: shareURl) else {
//            return false
//        }
//        let content: SharingContent!
//        content.contentURL = url
//
//        let delagate: SharingDelegate!
//        let shareDialog = ShareDialog(fromViewController: controller, content: content, delegate: delagate)
//        shareDialog.mode = .feedWeb
//        do {
//            try shareDialog.show()
//            return true
//        } catch (let error) {
//            let alert = UIAlertController(title: kAppName, message: "Failed to present share dialog with error \(error)", preferredStyle: .alert)
//
//            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alert.addAction(okAction)
//            controller.present(alert, animated: true, completion: nil)
//            return false
//        }
         return false
    }
 }
/*
 let content = FBSDKShareLinkContent()
 guard let str = shareURl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
 return false
 }
 
 guard let url = URL(string: str) else {
 return false
 }
 content.contentURL = url
 content.quote = "BibleAsk"
 
 let dialog: FBSDKShareDialog = FBSDKShareDialog()
 //        dialog.fromViewController = self
 // dialog.delegate = self      // make sure to conform to FBSDKSharingDelegate protocol
 dialog.shareContent = content
 dialog.mode = .feedWeb
 dialog.show()
 return false
 */
