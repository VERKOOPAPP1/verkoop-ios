//
//  Constants.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 15/11/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//



let kScreenWidth  = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height
let kAppDefaultColor = UIColor(hexString: "#E62311")
let kAppGreenColor = UIColor(hexString: "#67CA4C")
let kApporangeColor = UIColor(hexString: "#F9AA33")
let googleAPIKey = "AIzaSyDjTWXzAS6IvhCf7bscIyKYZXOUKsy4Tms"
let kAppName = Bundle.main.infoDictionary!["CFBundleName" as String] as! String

//@available(iOS 13.0, *)
//let kAppSceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
//@available(iOS 13.0, *)
//public let kKeyWindow = UIApplication.shared.connectedScenes
//    .filter({$0.activationState == .foregroundActive})
//    .map({$0 as? UIWindowScene})
//    .compactMap({$0})
//    .first?.windows
//    .filter({$0.isKeyWindow}).first
//
//@objcMembers
//@objc public class AppConstants: NSObject {
//    private override init() {
//
//    }
//
//    @objc public class func getKeyWindow() -> UIWindow {
//        if #available(iOS 13.0, *) {
//            return kKeyWindow ?? UIWindow()
//        } else {
//            return UIApplication.shared.keyWindow ?? UIWindow()
//        }
//    }
//
//    @objc public class func getStatusBarHeight() -> CGFloat {
//        if #available(iOS 13.0, *) {
//            return getKeyWindow().windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//        } else {
//            return UIApplication.shared.statusBarFrame.height
//        }
//    }
//}

struct Constants {
    static let sharedAppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let sharedUserDefaults  = UserDefaults.standard
    
    func getBrandSize() -> CGFloat {
        if kScreenHeight <= 568 {
            return kScreenHeight * 0.27
        } else if kScreenHeight <= 667 {
            return kScreenHeight * 0.21
        } else if kScreenHeight <= 736 {
            return kScreenHeight * 0.18
        } else if kScreenHeight <= 812 {
            return kScreenHeight * 0.16
        }
        return 145
    }
    
    func getCarBodySize() -> CGFloat {
        if kScreenHeight <= 568 {
            return kScreenHeight * 0.33
        } else if kScreenHeight <= 667 {
            return kScreenHeight * 0.25
        } else if kScreenHeight <= 736 {
            return kScreenHeight * 0.22
        } else if kScreenHeight <= 812 {
            return kScreenHeight * 0.19
        }
        return 165
    }

    func getBudgetFilterSize() -> CGFloat {
        if kScreenHeight <= 568 {
            return kScreenHeight * 0.4
        } else if kScreenHeight <= 667 {
            return kScreenHeight * 0.30
        } else if kScreenHeight <= 736 {
            return kScreenHeight * 0.27
        } else if kScreenHeight <= 812 {
            return kScreenHeight * 0.23
        }
        return 190
    }
    
    func getCarAndPropertySize() -> CGFloat {
        if kScreenHeight <= 568 {
            return kScreenHeight * 0.27
        } else if kScreenHeight <= 667 {
            return kScreenHeight * 0.25
        } else if kScreenHeight <= 736 {
            return kScreenHeight * 0.23
        } else if kScreenHeight <= 812 {
            return kScreenHeight * 0.21
        }
        return 200
    }
    
    func getItemSize() -> CGFloat {
        if kScreenHeight <= 568 {
            return kScreenHeight * 0.52
        } else if kScreenHeight <= 667 {
            return kScreenHeight * 0.49
        } else if kScreenHeight <= 736 {
            return kScreenHeight * 0.44
        } else if kScreenHeight <= 812 {
            return kScreenHeight * 0.38
        }
        return 320
    }
    
    func getCategorySize() -> CGFloat {
        return kScreenWidth * 0.4
//        if kScreenHeight <= 568 {
//            return kScreenHeight * 0.23
//        } else if kScreenHeight <= 667 {
//            return kScreenHeight * 0.23
//        } else if kScreenHeight <= 736 {
//            return kScreenHeight * 0.23
//        } else if kScreenHeight <= 812 {
//            return kScreenHeight * 0.24
//        }
//        return 200
    }
}

struct NotificationName {
    static let RefreshController = "RefreshController"
    static let SwitchTabBarController = "SwitchTabBarController"
    static let GetSelectedCity = "GetSelectedCity"
    static let GetSelectedBrand = "GetSelectedBrand"
    static let GetSelectedZone = "GetSelectedZone"
    static let UpdateOfferStatusType = "UpdateOfferStatusType"
    static let MakeOffer = "MakeOffer"
    static let RefreshLastChat = "RefreshLastChat"
    static let CoinPurchased = "CoinPurchased"
    static let BannerSubmited = "BannerSubmited"
}

struct Titles {
    static let postComment = "Post a comment"
    static let comments = "Comments"
    static let gender = "Gender"
    static let dob = "Set your date of birth"
    static let camera = "Camera"
    static let gallery = "Gallery"
    static let cancel = "Cancel"
    static let submit = "Submit"
    static let ok = "Ok"
    static let male = "Male"
    static let female = "Female"
    static let searchCity = "Search City"
    static let searchState = "Search Region"
    static let blockUser = "Block User"
    static let unblockUser = "Unblock User"
    static let reportUser = "Report User"
    static let reportList = "Report List"
    static let share = "Share"
    static let editListing = "Edit Listing"
    static let markSold = "Mark as Sold"
    static let deleteListing = "Delete Listing"
    static let deleteAlert = "Delete Item"
    static let viewProfile = "View Profile"
    static let clearChat = "Clear Chat"
    static let viewSeller = "View Seller"
    static let makeOffer = "Make Offer"
    static let editOffer = "Edit Offer"
    static let cancelOffer = "Cancel Offer"
    static let acceptOffer = "Accept Offer"
    static let declineOffer = "Decline Offer"
    static let leaveReviewForBuyer = "Rate this Buyer"
    static let leaveReviewForSeller = "Rate this Seller"
}
 
struct ReuseIdentifier {
    static let NotificationCell = "NotificationCell"
    static let UserRatingTableCell = "UserRatingTableCell"
    static let ReceiverRateTableCell = "ReceiverRateTableCell"
    static let SenderRateTableCell = "SenderRateTableCell"
    static let OTPVerificationView = "OTPVerificationView"
    static let CountryCodeTableCell = "CountryCodeTableCell"
    static let ReceiverImageTableCell = "ReceiverImageTableCell"
    static let SenderImageTableCell = "SenderImageTableCell"
    static let TransferMoneyToFriendView = "TransferMoneyToFriendView"
    static let BannerListCell = "BannerListCell"
    static let SubmitBannerView = "SubmitBannerView"
    static let AddMoneyPopup = "AddMoneyPopup"
    static let TransactionHistoryCell = "TransactionHistoryCell"
    static let PropertyTypeCell = "PropertyTypeCell"
    static let ParkingTableCell = "ParkingTableCell"
    static let SenderOfferTableCell = "SenderOfferTableCell"
    static let ReceiverOfferTableCell = "ReceiverOfferTableCell"
    static let ReceiverMessageTableCell = "ReceiverMessageTableCell"
    static let SenderMessageTableCell = "SenderMessageTableCell"
    static let ChatListTableCell = "ChatListTableCell"
    static let AllBrandCell = "AllBrandCell"
    static let PropertyDetailCell = "PropertyDetailCell"
    static let CarDetailCell = "CarDetailCell"
    static let BedroomBathroomCell = "BedroomBathroomCell"
    static let SwitchCell = "SwitchCell"
    static let CarAndPropertyCell = "CarAndPropertyCell"
    static let BrandsCollectionCell = "BrandsCollectionCell"
    static let CarBrandsCell = "CarBrandsCell"
    static let BuyPackageCell = "BuyPackageCell"
    static let BudgetCell = "BudgetCell"
    static let CustomDatePickerView = "CustomDatePickerView"
    static let RateUserView = "RateUserView"
    static let MakeOfferView = "MakeOfferView"
    static let DefaultCell = "DefaultCell"
    static let FilterCategoryImageCell = "FilterCategoryImageCell"
    static let AllCategoryHorizontalCell = "AllCategoryHorizontalCell"
    static let ChangePasswordView = "ChangePasswordView"
    static let ProfileTextFieldCell = "ProfileTextFieldCell"
    static let ProfileDropDownCell = "ProfileDropDownCell"
    static let ProfilePhotoCell = "ProfilePhotoCell"
    static let SingleLabelCell = "SingleLabelCell"
    static let CommentTableCell = "CommentTableCell"
    static let SingleCollectionViewCell = "SingleCollectionViewCell"
    static let SingleButtonTableCell = "SingleButtonTableCell"
    static let TextViewCell = "TextViewCell"
    static let SelectLocationCell = "SelectLocationCell"
    static let SearchedUserCell = "SearchedUserCell"
    static let SearchItemCell = "SearchItemCell"
    static let TitleAndCheckBoxCell = "TitleAndCheckBoxCell"
    static let MeetupLocationCell = "MeetupLocationCell"    
    static let onboardingCollectionCell = "OnboardingCollectionCell"
    static let selectCategoryCollectionCell = "SelectCategoryCollectionCell"
    static let adsCollectionCell = "AdsCollectionCell"
    static let categoryCollectionCell = "CategoryCollectionCell"
    static let itemsCollectionCell = "ItemsCollectionCell"
    static let filterCollectionCell = "FilterCollectionCell"
    static let categoryItemCollectionCell = "CategoryItemCollectionCell"
    static let filterDetailCollectionCell = "FilterDetailCollectionCell"
    static let sortFilterTableCell = "SortFilterTableCell"
    static let itemConditionFilterTableCell = "ItemConditionFilterTableCell"
    static let MobileTableCell = "MobileTableCell"    
    static let priceTableCell = "PriceTableCell"
    static let tableCellSelectedPhotos = "TableCellSelectedPhotos"
    static let collectionCellAddItem = "CollectionCellAddItem"
    static let tableCellSelectCategory = "TableCellSelectCategory"
    static let addDetailHeaderView = "AddDetailHeaderView"
    static let profileHeaderView = "ProfileHeaderView"
    static let OthersProfileHeaderView = "OthersProfileHeaderView"    
    static let collectionCellProductDetail = "CollectionCellProductDetail"
    static let tableCellProductDetail = "TableCellProductDetail"
    static let tableCellItemDetail = "TableCellItemDetail"
    static let tableCellShare = "TableCellShare"
    static let collectionCellSelectedPhotos  = "CollectionCellSelectedPhotos"
    static let collectionCellCategories = "CollectionCellCategories"
    static let categoriesHeader = "CategoriesHeader"
    static let CommentListCell = "CommentListCell"    
}

struct SocketEvent {
    static let initEvent = "init"
    static let rateUser = "rateUser"    
    static let makeOffer = "makeOffer"
    static let acceptOffer = "acceptOffer"
    static let declineOffer = "declineOffer"
    static let cancelOffer = "cancelledOffer"
    static let sendMessages = "messages"
    static let getLatestChat = "messagelists"
    static let receiveMessage = "receiveMessage"
    static let inboxList = "inboxList"
    static let archiveChat = "archiveChat"
    static let unarchiveChat = "unarchiveChat"
    static let deleteChat = "deleteChat"
    static let readMessage = "readMessage"
    static let directChat = "directChat"
}

struct API {
    static let placeAPIKey = "AIzaSyAHmvA7vk4dOVb70HD82ZmQQK66h0rsjEc"
//    static let baseUrl     = "http://mobile.serveo.net/verkoop/api/V1/"
    static let baseUrl     = "http://verkoopadmin.com/VerkoopApp/api/V1/"
    //http://verkoopadmin.com/VerkoopApp/api/V1/
    static let assetsUrl   = "http://verkoopadmin.com/VerkoopApp/"
    static let googleURL   = "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)"
}

struct PaymentUrl {
    static let paymentUrl = "http://mudaribapp.com:5000/payment.html?id="
    static let sucessUrl = "http://mudaribapp.com:5000/payment_message.html?msg=successfully"
    static let failureUrl = "http://mudaribapp.com:5000/payment_message.html?msg=failed"
}

struct ErrorMessages {
    static let unauthorizedAccess = "Invalid account detail"
    static let errorToHandleInSuccess = "Something is wrong while getting success"
    static let errorToHandleInFailure = "Something is wrong while getting failure"
    static let errorNothingToLog = "There is nothing to log on console"
    static let somethingWentWrong = "Something went wrong"
    static let unableToParseError = "Unable to parse error response"
    static let invalidUserId = "Unable to find userId"
    static let networkError = "Network not available"
}

struct Messages {
    static let maximumCount = "Maximum count reached"
}

struct DebugMessages {
    static let wrongScreen = "Error in screen transition"
}

struct Validation {
    static let errorEnterOldPassword = "Please enter old password."
    static let errorEnterNewPassword = "Please enter new password."
    static let errorEnterConfirmPassword = "Please enter confirm password."
    static let errorEmptyCountry = "Please select country."
    static let errorEmptyPhoneNumber = "Please enter phone number."
    static let errorEmptyCountryField = "Please select Country."
    static let errorNotNumeric = "Please enter numbers."
    static let errorPhoneLength = "Phone Number should be between 8 to 15 digits."
    static let errorNameEmpty = "Please enter name."
    static let invalidUserName = "Username should not contain space."
    static let errorNameInvalid = "Please enter valid name"
    static let errorNameLength = "Name should be between 3 to 10 characters. "
    static let errorEmailEmpty = "Please enter Email Id."
    static let errorEmailInvalid = "Please enter valid Email Id."
    static let errorPasswordEmpty = "Please enter password."
    static let errorPasswordInvalid = "Password must contain characters between 8 to 15 and it must be alphanumeric."
    static let errorPasswordLength = "Password should be less than 15 characters."
    static let errorPasswordLengthInvalid = "Password must contain at least 6 characters."
    static let errorConfirmPasswordLengthInvalid = "Password must contain at least 6 characters."
    static let errorPasswordMismatch = "Password and confirm password should be same."
    static let errorInvalidCountry = "Please select country."
}

struct Console {
    static func log(_ message: Any?) {
//        print(message ?? ErrorMessages.errorNothingToLog)
    }
}

struct ServerKeys {
    static let banner = "banner"
    static let token = "token"
    static let chatImage = "chat_image"
    static let profile_pic = "profile_pic"
    static let image = "image"
    static let message = "message"
    static let errors = "errors"
    static let firstName = "FirstName"
    static let lastName = "lastName"
    static let email = "email"
    static let normal = "normal"
    static let social = "social"
    static let socialId = "social_id"
    static let requestType = "login_type"
    static let password = "password"
    static let data = "data"
    static let userName = "username"
    static let country = "country"
}

struct MethodName {
    static let goodRating = "listRatedUserGood"
    static let badRating = "listRatedUserBad"
    static let averageRating = "listRatedUserAverage"
    static let bannerDetails = "bannerDetails"
    static let ratings = "ratings"
    static let friendInfo = "user/friendInfo"
    static let send_money = "send_money"
    static let userPurchaseAdvertisement = "userPurchaseAdvertisement"
    static let renewAdvertisement = "renew_advertisement"
    static let user_coin = "user_coin"
    static let payments = "payments"
    static let getNotificationList = "get_activity_list"
    static let coin_plans = "coin_plans"
    static let advertisment_plans = "advertisment_plans"
    static let chatImageUpload = "chatImageUpload"
    static let otherUserProfile = "user/itemCreateProfileData"
    static let userProfile = "user/profile/"
    static let register = "user/register"
    static let login = "user/login"
    static let logout = "user/logout"
    static let brands = "getBrandWithModels"
    static let getCategories = "categories"
    static let getItem = "dashboard/"
    static let nearByPlacesAPI = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@&radius=%@&key=%@"
    static let searchAPI = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=%@"
    static let likes = "likes"
    static let item_details = "item_details"
    static let deactivateAccount = "user/deactivate_account"
    static let addItem = "items"
    static let updateItem = "updateItem"
    static let updateDeviceToken = "user/updateDeviceInfo"
    static let filterCategories = "categoryFilterData/"
    static let getFavouriteCategories = "getUserFavouriteData/"
    static let carFilterData = "carAndPropertyFilterData/"
    static let updateProfile = "user/profileUpdate"
    static let followUser = "follows"
    static let blockUser = "block_users"
    static let reportsUser = "reports"
    static let markSold = "markAsSold/"
    static let comments = "comments"
    static let userSelectedCategory = "user/selectedUserCategroy"
    static let searchByUserName = "user/searchByUserName"
    static let searchByKeyword = "searchKeywordData"
    static let searchByRecognizedTag = "searchKeywordMultipleData"    
    static let changePassword = "user/changePassword"
    static let forgotPassword = "user/forgot_password"
    static let getUserListFollow = "getUserListFollow"
    static let requestOTP = "user/changePhoneNo"
    static let verifyMobile = "user/mobileVerified"    
}

struct StatusCode {
    static let success = 200
    static let pageNotFound = 404
    static let unauthorized = 401
    static let noDataFound = 400
    static let alreadyReported = 208
    static let resourceCreated = 201    
}

enum LoginType: String {
    case normal
    case facebook
    case google
}

enum CurrentScreen: String {
    case category
    case option
    case dashboard
}

enum HomeScreenCollectionView: Int {
    case advertisment = 0
    case category = 1
    case item = 2
    case dailyPicks = 3
}

enum AddDetailDictKeys: String {
    case type = "type"
    case brand_name = "brand_name"
    case model_name = "model_name"
    case model_id = "model_id"
    case brand_id = "brand_id"
    case location = "location"
    case zone_id = "zone_id"
    case additional_info = "additional_info"
    case label = "label"
    case image = "image"
    case base64String = "base64String"
    case category_id = "category_id"
    case category_name = "category_name"
    case parent_name = "parent_name"
    case name = "name"
    case price = "price"
    case property_type = "property_type"
    case parking_type = "parking_type"
    case minPrice = "min_price"
    case maxPrice = "max_price"
    case fromYear = "from_year"
    case toYear = "to_year"
    case furnished = "furnished"
    case transmission_type = "transmission_type"
    case item_type = "item_type"
    case description = "description"
    case user_id = "user_id"
    case latitude = "latitude"
    case longitude = "longitude"
    case address = "address"
    case meet_up = "meet_up"
    case image_remove_id = "image_remove_id"
    case item_id = "item_id"
    case street_name = "street_name"
    case postal_code = "postal_code"
    case city = "city"
    case bedroom = "bedroom"
    case bathroom = "bathroom"
    case direct_owner = "direct_owner"
}

enum UpdateProfileKeys: String {
    case state = "state"
    case country = "country"
    case city_id = "city_id"
    case state_id = "state_id"
    case country_id = "country_id"
    case email = "email"
    case mobile = "mobile_no"
    case user_id = "user_id"
    case username = "username"
    case first_name = "first_name"
    case last_name = "last_name"
    case city = "city"
    case bio = "bio"
    case profile_pic = "profile_pic"
    case gender = "gender"
    case DOB = "DOB"
    case website = "website"
}

enum FilterKeys: String {
    case category_id = "category_id"
    case item_type = "item_type"
    case latitude = "latitude"
    case longitude = "longitude"
    case max_price = "max_price"
    case meet_up = "meet_up"
    case min_price = "min_price"
    case sort_no = "sort_no"
    case type = "type"
    case userId = "userId"
    case item_id = "item_id"
}
