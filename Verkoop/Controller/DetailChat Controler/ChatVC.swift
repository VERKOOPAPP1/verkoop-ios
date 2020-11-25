//
//  ChatVC.swift
//  Verkoop
//
//  Created by Vijay on 07/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit
import CoreData

class ChatVC: UIViewController {

    //MARK:- Outlets and Variable Declaration
    //MARK:-
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var textViewContainer: UIView!
    @IBOutlet weak var messageTextView: AUIAutoGrowingTextView!
    @IBOutlet weak var productViewTopContraint: NSLayoutConstraint!
    @IBOutlet weak var buttonViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstButtonWidthConstraint: NSLayoutConstraint!
    
    var itemType: ItemType = .generic
    var isPopupPresent = false
    var chatUserId = "0"
    var isMyItem = false
    var receiverId = ""
    var userImage: UIImage?
    var isUserBlocked = false
    var info: [String:String] = [:]
    var isBlockAPIDataLoading = false
    var imagePicker = UIImagePickerController()
    var senderId = Constants.sharedUserDefaults.getUserId()
    var fetchResultController:NSFetchedResultsController<NSFetchRequestResult>!
    var offerFromProductVC = "" // When User makes the offer from Product screen
    
    enum OfferStaus: Int {
        case offerMade
        case offerAccepted
        case offerDiscarded
        case itemSoldToOther
        case itemSoldToMe
        case noActionPerform
    }
    
    var offerStatusType: OfferStaus = .noActionPerform
    
    //MARK:- Life Cycle Delegates
    //MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        getChat()
    }
    
    fileprivate func initialSetup() {
        
        receiverId = info["otherUserId"]!
        nameLabel.text = info["username"]
        timeLabel.text = info["created_at"]
        productNameLabel.text = info["product_name"]
        priceLabel.text = "R " + info["price"]!
        
        self.fetchResultController = (NSFetchedResultsController(fetchRequest: self.chatFetchRequest(), managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>)
        self.fetchResultController.delegate = self
        
        var infoImage = UIImage(named: "more")?.rotateImage(degrees: CGFloat(Double.pi/2))
        infoImage = infoImage?.imageWithColor(.white)
        moreButton.setImage(infoImage, for: .normal)
        
        let profileURl = (API.assetsUrl + info["profile_pic"]!).replacingOccurrences(of: "\\", with: "/")
        profileImageView.makeRoundCorner(profileImageView.frame.height/2)
        if let mergeUrl = URL(string: profileURl) {
            profileImageView.kf.setImage(with: mergeUrl, placeholder: UIImage(named: "pic_placeholder"))
        } else {
            profileImageView.image = UIImage(named: "pic_placeholder")
        }
        
        let productURl = API.assetsUrl + info["product_pic"]!.replacingOccurrences(of: "\\", with: "/")
        if let mergeUrl = URL(string: productURl) {
            productImage.kf.setImage(with: mergeUrl, placeholder: UIImage(named: "pic_placeholder"))
        } else {
            productImage.image = UIImage(named: "pic_placeholder")
        }
        
        messageTextView.placeholder = "Enter here..."
        messageTextView.placeholderColor = .lightGray
        messageTextView.minHeight = 32
        messageTextView.maxHeight = 100
        messageTextView.enablesReturnKeyAutomatically = true
        messageTextView.delegate = self
        
        firstButton.addTarget(self, action: #selector(firstButtonAction(_:)), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(secondButtonAction(_:)), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(moreButtonAction(_:)), for: .touchUpInside)
        
        chatTableView.register(UINib(nibName: ReuseIdentifier.SenderRateTableCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.SenderRateTableCell)
        chatTableView.register(UINib(nibName: ReuseIdentifier.ReceiverRateTableCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ReceiverRateTableCell)
        chatTableView.register(UINib(nibName: ReuseIdentifier.ReceiverImageTableCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ReceiverImageTableCell)
        chatTableView.register(UINib(nibName: ReuseIdentifier.SenderImageTableCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.SenderImageTableCell)
        chatTableView.register(UINib(nibName: ReuseIdentifier.SenderMessageTableCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.SenderMessageTableCell)
        chatTableView.register(UINib(nibName: ReuseIdentifier.ReceiverMessageTableCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ReceiverMessageTableCell)
        chatTableView.register(UINib(nibName: ReuseIdentifier.ReceiverOfferTableCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.ReceiverOfferTableCell)
        chatTableView.register(UINib(nibName: ReuseIdentifier.SenderOfferTableCell, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.SenderOfferTableCell)
        chatTableView.estimatedRowHeight = 81
        chatTableView.rowHeight = UITableView.automaticDimension
        handleTwoButton()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateOfferStatus(_:)), name: NSNotification.Name(rawValue: NotificationName.UpdateOfferStatusType), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeOfferFromProductVC(_:)), name: NSNotification.Name(rawValue: NotificationName.MakeOffer), object: nil)
    }
    
    @objc func updateOfferStatus(_ notification: Notification) {
        if let userInfo = notification.userInfo , let type = userInfo["type"] as? String {
            switch type {
            case "2":
                offerStatusType = .offerMade
            case "3":
                if isMyItem {
                    offerStatusType = .offerAccepted
                } else {
                    offerStatusType = .itemSoldToMe
                }
            case "4":
                offerStatusType = .noActionPerform
            case "5":
                offerStatusType = .noActionPerform
            case "6":
                offerStatusType = .itemSoldToOther
            default:
                Console.log("Do Nothing")
            }
        }
        handleTwoButton()
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.RefreshLastChat), object: nil, userInfo: [:])        
    }
    
    @objc func makeOfferFromProductVC(_ notification: Notification) {
        if let userInfo = notification.userInfo, let status = userInfo["status"] as? String, status == "1" , offerFromProductVC.count > 0 {
            delay(time: 2.0) {
                self.didClickMakeOfferButton(price: self.offerFromProductVC)
            }
        }
    }
    
    func handleTwoButton() {
        buttonViewHeightConstraint.constant = 40
        firstButtonWidthConstraint.constant = kScreenWidth * 0.5 - 1.5
        if isMyItem {
            switch offerStatusType {
            case .offerMade:
                firstButton.setTitle(Titles.declineOffer, for: .normal)
                secondButton.setTitle(Titles.acceptOffer, for: .normal)
            case .offerAccepted: //From this user
                firstButtonWidthConstraint.constant = 0
                secondButton.setTitle(Titles.leaveReviewForBuyer, for: .normal)
            case .offerDiscarded:  //Offer Discarded
                fallthrough
            case .itemSoldToMe:
                fallthrough
            case .noActionPerform:// No Action performed yet
                buttonViewHeightConstraint.constant = 0
            case .itemSoldToOther:  //Sold to other User
                buttonViewHeightConstraint.constant = 0                
            }
        } else {
            switch offerStatusType {
            case .offerMade: //Offer Made by me
                firstButton.setTitle(Titles.cancelOffer, for: .normal)
                secondButton.setTitle(Titles.editOffer, for: .normal)
            case .itemSoldToOther:  //Sold to other User
                buttonViewHeightConstraint.constant = 0
            case .itemSoldToMe: //Sold to me
                firstButtonWidthConstraint.constant = 0
                secondButton.setTitle(Titles.leaveReviewForSeller, for: .normal)
            case .noActionPerform:// No Action performed yet
                firstButton.setTitle(Titles.viewSeller, for: .normal)
                secondButton.setTitle(Titles.makeOffer, for: .normal)
            case .offerAccepted: //From this user
                break
            case .offerDiscarded:  //Offer Discarded
                break

            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationName.UpdateOfferStatusType), object: nil)
    }

    //MARK:- Private Methods
    //MARK:-
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if !isPopupPresent {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                productViewTopContraint.constant = -65
                textViewContainerBottomConstraint.constant = keyboardSize.size.height
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                }) { finished in
                    self.scrollToBottom(animated: true)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if !isPopupPresent {
            productViewTopContraint.constant = 0
            textViewContainerBottomConstraint.constant = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func scrollToBottom(animated: Bool = false) {
        if let sections = fetchResultController.sections, sections.count > 0 {
            let sectionNo = sections.count - 1
            let rows = sections[sectionNo].numberOfObjects - 1
            if rows > 0 , chatTableView.numberOfRows(inSection: 0) > 0 {
                DispatchQueue.main.async {
                    self.chatTableView.scrollToRow(at: IndexPath(row: rows, section: sectionNo), at: .bottom, animated: animated)
                }
            }
        }
    }
    
    func getChat() {
        CoreDataManager.getChats(fetchedResultsController: fetchResultController) { [weak self] (success:Bool, error:NSError?) in
            if let error = error {
                DisplayBanner.show(message: error.localizedDescription)
                return
            }
            if success {
                DispatchQueue.main.async {
                    self?.chatTableView.reloadData()
                    self?.scrollToBottom()
                    self?.delay(time: 0.1, completionHandler: {
                        self?.getLastMessages()
                    })
                }
            }
        }
    }
    
    @objc func getLastMessages() {
        if SocketHelper.shared.socketStatus() == .connected {
            let params = ["sender_id": senderId, "item_id": info["item_id"]!, "receiver_id": receiverId, "price": info["price"]!]
            SocketHelper.shared.getChatUserId(param: params) { (status, chatUserId) -> (Void) in
                self.chatUserId = chatUserId
                if let chat = self.getLastChat() {
                    let params = ["sender_id": self.senderId, "receiver_id": self.receiverId, "item_id": self.info["item_id"]!, "message_id": String.getString(chat.messageId)]
                        as [String : String]
                    SocketHelper.shared.getLatestMessages(params: params)
                } else {
                    let params = ["sender_id": self.senderId, "receiver_id": self.receiverId, "item_id": self.info["item_id"]!, "message_id": "0"]
                        as [String : String]
                    SocketHelper.shared.getLatestMessages(params: params)
                }
            }
        }
    }
    
    func getLastChat() -> Chat? {
        if let sections = fetchResultController.sections, sections.count > 0 {
            return sections.first?.objects?.last as? Chat
        }
        return nil
    }
    
    func getLastOfferPrice() -> String? {
        if let sections = fetchResultController.sections, sections.count > 0 {
            if let chatArray = sections.first?.objects as? [Chat] {
                if let lastChat =  chatArray.last(where: {($0.messageType == "2" || $0.messageType ==  "4" || $0.messageType == "5")}) {
                    if lastChat.messageType == "2" { //Offer Made by Buyer
                        return lastChat.message
                    } else{ //Offer Cancelled by Buyer OR Offer Declined by Seller
                        return info["price"]
                    }
                }
            }
        }
        return nil
    }
    
    func chatFetchRequest() -> NSFetchRequest<Chat> {
        let fetchRequest:NSFetchRequest<Chat> = Chat.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "((senderId == %@ AND receiverId == %@) OR (senderId == %@ AND receiverId == %@)) AND itemId == %i", senderId, receiverId ,receiverId ,senderId, Int.getInt(info["item_id"]))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "messageId", ascending: true)]
        return fetchRequest
    }
    
    @IBAction func productDetailButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectMediaButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        openActionSheet()
    }
    
    @IBAction func sendMessageButton(_ sender: Any) {
        if let text = messageTextView.text , text.count > 0 {
            if SocketHelper.shared.socketStatus() == .connected {
                sendButton.isEnabled = false
                sendButton.alpha = 0.8
                
                if chatUserId != "0" {
                    SocketHelper.shared.sendMessage(params: ["chat_user_id": chatUserId,
                                                             "sender_id":senderId,
                                                             "receiver_id": receiverId,
                                                             "item_id": info["item_id"]!,
                                                             "message": text.sendEncodedString(),
                                                             "type": "0"])
                } else {
                    let params = ["sender_id": senderId, "item_id": info["item_id"]!, "receiver_id": receiverId, "price": info["price"]!]
                    SocketHelper.shared.getChatUserId(param: params) { (status, chatUserId) -> (Void) in
                        self.chatUserId = chatUserId
                        SocketHelper.shared.sendMessage(params: ["chat_user_id": self.chatUserId,
                                                                 "sender_id": self.senderId,
                                                                 "receiver_id": self.receiverId,
                                                                 "item_id": self.info["item_id"]!,
                                                                 "message": text.sendEncodedString(),
                                                                 "type": "0"])
                    }
                }
                messageTextView.text = ""
            } else {
                DisplayBanner.show(message: "There is some connection problem")
            }
        }
    }
    
    func sendImageURLForChat(urlString: String) {
        if chatUserId != "0" {
            SocketHelper.shared.sendMessage(params: ["chat_user_id": chatUserId,
                                                     "sender_id":senderId,
                                                     "receiver_id": receiverId,
                                                     "item_id": info["item_id"]!,
                                                     "message": urlString,
                                                     "type": "1"])
        } else {
            let params = ["sender_id": senderId, "item_id": info["item_id"]!, "receiver_id": receiverId, "price": info["price"]!]
            SocketHelper.shared.getChatUserId(param: params) { (status, chatUserId) -> (Void) in
                self.chatUserId = chatUserId
                SocketHelper.shared.sendMessage(params: ["chat_user_id": self.chatUserId,
                                                         "sender_id": self.senderId,
                                                         "receiver_id": self.receiverId,
                                                         "item_id": self.info["item_id"]!,
                                                         "message": urlString,
                                                         "type": "1"])
            }
        }
    }

    @IBAction func ViewSellerButtonAction(_ sender: UIButton) {
        let profileVC = OtherUserProfileVC()
        profileVC.userId = self.info["otherUserId"]!
        profileVC.userName = self.info["username"]!
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    @objc func firstButtonAction(_ sender: UIButton) {
        if sender.titleLabel?.text == Titles.viewSeller {
            let profileVC = OtherUserProfileVC()
            profileVC.userId = self.info["otherUserId"]!
            profileVC.userName = self.info["username"]!
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
        } else if sender.titleLabel?.text == Titles.cancelOffer {
            if SocketHelper.shared.socketStatus() == .connected {
                let alertController = UIAlertController(title:"Cancel Offer", message: "Are you sure you want to cancel this offer?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: Titles.ok, style: .default, handler: { (action) in
                    self.sendButton.isEnabled = false
                    self.sendButton.alpha = 0.8
                    if let lastOffer = self.getLastOfferPrice() {
                        SocketHelper.shared.offerEvent(params: ["chat_user_id": self.chatUserId,
                                                                "sender_id": self.senderId,
                                                                "receiver_id": self.receiverId,
                                                                "item_id": self.info["item_id"]!,
                                                                "message": lastOffer,
                                                                "type": "5",
                                                                "price": lastOffer],
                                                       socketEvent: SocketEvent.cancelOffer)
                    }
                    self.messageTextView.text = ""
                })
                let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                alertController.view.tintColor = .darkGray
                OperationQueue.main.addOperation {
                    self.present(alertController, animated: true, completion: nil)
                }
            } else {
                DisplayBanner.show(message: "There is some connection problem")
            }
        } else if sender.titleLabel?.text == Titles.declineOffer {
            if SocketHelper.shared.socketStatus() == .connected {                
                let alertController = UIAlertController(title:"Cancel Offer", message: "Are you sure you want to cancel this offer?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: Titles.ok, style: .default, handler: { (action) in
                    self.sendButton.isEnabled = false
                    self.sendButton.alpha = 0.8
                    if let lastOffer = self.getLastOfferPrice() {
                        SocketHelper.shared.offerEvent(params: ["chat_user_id": self.chatUserId,
                                                                "sender_id": self.senderId,
                                                                "receiver_id": self.receiverId,
                                                                "item_id": self.info["item_id"]!,
                                                                "message": lastOffer,
                                                                "type": "4",
                                                                "price": lastOffer],
                                                       socketEvent: SocketEvent.declineOffer)
                    }
                    self.messageTextView.text = ""
                })
                let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                alertController.view.tintColor = .darkGray
                OperationQueue.main.addOperation {
                    self.present(alertController, animated: true, completion: nil)
                }
            } else {
                DisplayBanner.show(message: "There is some connection problem")
            }
        }
    }
    
    @objc func secondButtonAction(_ sender: UIButton) {
        if sender.titleLabel?.text == Titles.acceptOffer {
            let alertVC = UIAlertController(title: "Accept Offer", message: "Once the offer has been accepted, the product will be marked as sold.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                if SocketHelper.shared.socketStatus() == .connected {
                    self.sendButton.isEnabled = false
                    self.sendButton.alpha = 0.8
                    if let lastOffer = self.getLastOfferPrice() {
                        SocketHelper.shared.offerEvent(params: ["chat_user_id": self.chatUserId,
                                                                "sender_id": self.senderId,
                                                                "receiver_id": self.receiverId,
                                                                "item_id": self.info["item_id"]!,
                                                                "message": lastOffer ,
                                                                "type": "3",
                                                                "price": lastOffer],
                                                       socketEvent: SocketEvent.acceptOffer)
                    }
                    self.messageTextView.text = ""
                } else {
                    DisplayBanner.show(message: "There is some connection problem")
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertVC.addAction(okAction)
            alertVC.addAction(cancelAction)
            DispatchQueue.main.async {
                self.present(alertVC, animated: true, completion: nil)
            }
        } else if sender.titleLabel?.text == Titles.editOffer || sender.titleLabel?.text == Titles.makeOffer {
            view.endEditing(true)
            if let makeOfferView = Bundle.main.loadNibNamed(ReuseIdentifier.MakeOfferView, owner: self, options: nil)?.first as? MakeOfferView {
                makeOfferView.frame = view.frame
                makeOfferView.delegate = self
                if let lastOffer = getLastOfferPrice() {
                    makeOfferView.priceField.text = lastOffer
                } else if itemType == .generic {
                    makeOfferView.priceField.text = info["price"]!
                } else  {
                    makeOfferView.priceField.text = info["max_price"]!
                }
                if itemType == .generic {
                    makeOfferView.userOffer = Double.getDouble(info["price"]) * 0.6
                } else {
                    makeOfferView.userOffer = Double.getDouble(info["price"])
                }
                isPopupPresent = true
                view.addSubview(makeOfferView)
                delay(time: 0.1) {
                    makeOfferView.animateView(isAnimate: true)
                }
            }
        } else if sender.titleLabel?.text == Titles.leaveReviewForBuyer {
            //Rate Buyer
            view.endEditing(true)
            if let rateUserView = Bundle.main.loadNibNamed(ReuseIdentifier.RateUserView, owner: self, options: nil)?.first as? RateUserView {
                rateUserView.frame = view.frame
                rateUserView.delegate = self
                rateUserView.ratingUserLabel.text = "Rate this Buyer"
                rateUserView.layoutIfNeeded()
                view.addSubview(rateUserView)
                rateUserView.topConstraint.constant = kScreenHeight
                rateUserView.animateView(isAnimate: true)
            }
        } else if sender.titleLabel?.text == Titles.leaveReviewForSeller {
            //Rate Seller
            view.endEditing(true)
            if let rateUserView = Bundle.main.loadNibNamed(ReuseIdentifier.RateUserView, owner: self, options: nil)?.first as? RateUserView {
                rateUserView.frame = view.frame
                rateUserView.delegate = self
                rateUserView.ratingUserLabel.text = "Rate this Seller"
                rateUserView.layoutIfNeeded()
                view.addSubview(rateUserView)
                rateUserView.topConstraint.constant = kScreenHeight
                rateUserView.animateView(isAnimate: true)
            }
        }
    }
    
    @objc func moreButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        let alertController = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        
        let blockUser = UIAlertAction(title: isUserBlocked ? Titles.unblockUser : Titles.blockUser, style: .default) { (action) in
            
            let alertVC = UIAlertController(title: self.isUserBlocked ? Titles.unblockUser : Titles.blockUser, message: self.isUserBlocked ? "Do you want to unblock this user?" : "Do you want to block this user?", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "YES", style: .default, handler: { (action) in
                if !self.isBlockAPIDataLoading {
                    self.isBlockAPIDataLoading = true
                    if self.isUserBlocked {
                        self.unblockUser(id: "")
                    } else {
                        self.blockUser()
                    }
                    self.isUserBlocked = !self.isUserBlocked
                }
            })
            let cancelButton = UIAlertAction(title: "NO", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            alertVC.addAction(okButton)
            alertVC.addAction(cancelButton)
            alertVC.view.tintColor = .darkGray
            DispatchQueue.main.async {
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        
        let reportUser = UIAlertAction(title: Titles.reportUser, style: .default) { (action) in
            let reportView = CustomActionSheet(frame: self.view.frame)
            reportView.initializeSetup()
            reportView.delegate = self
            self.view.addSubview(reportView)
            reportView.reports = []
            reportView.tableView.reloadData()
            self.delay(time: 0.05, completionHandler: {
                reportView.animateView(isAnimate: true)
            })
        }
        
//        let clearChat = UIAlertAction(title: Titles.clearChat, style: .default) { (action) in
//            self.dismiss(animated: true, completion: nil)
//        }
        
        let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel, handler: nil)
        
        alertController.addAction(blockUser)
        alertController.addAction(reportUser)
//        alertController.addAction(clearChat)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = .darkGray
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func makeOfferButton(_ sender: UIButton) {
        if let makeOfferView = Bundle.main.loadNibNamed(ReuseIdentifier.MakeOfferView, owner: self, options: nil)?.first as? MakeOfferView {
            makeOfferView.frame = view.frame
            makeOfferView.delegate = self
            if let lastOffer = getLastOfferPrice() {
                makeOfferView.priceField.text = lastOffer
            } else if itemType == .generic {
                makeOfferView.priceField.text = info["price"]!
            } else {
                makeOfferView.priceField.text = info["max_price"]!
            }
            if itemType == .generic {
                makeOfferView.userOffer = Double.getDouble(info["price"]) * 0.6
            } else {
                makeOfferView.userOffer = Double.getDouble(info["min_price"])
            }
            view.addSubview(makeOfferView)
            delay(time: 0.1) {
                DispatchQueue.main.async {
                    makeOfferView.animateView(isAnimate: true)
                }
            }
        }
    }    
}
