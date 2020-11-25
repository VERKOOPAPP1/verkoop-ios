//
//  ProductDetailVC.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 04/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

class ProductDetailVC: UIViewController {

    var itemType = ItemType.generic
    var isMyItem = false
    var isItemSold = false
    var itemId = ""
    var productDetail: ProductModel?
    var customPageControl : UIPageControl!
    var advertiseCollectionView : UICollectionView!
    let dummyCount = 3
    var timer: Timer?
    var timerStarted = false
    var lastContentOffset: CGFloat = 0
    var delegate: RefreshScreen?
    var refreshRequired = false
    
    var cellWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var totalContentWidth: CGFloat {
        if let detail = productDetail , let count = detail.data?.items_image?.count {
            return  CGFloat(count * dummyCount) * cellWidth
        } else {
            return cellWidth
        }
    }
    
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var makeOfferWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var offerButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var makeOfferButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var tableProductDetail: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        getItemDetailService(params: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    fileprivate func initialSetup() {
        UIApplication.shared.statusBarView?.backgroundColor =  kAppDefaultColor
        bottomContainerView.isHidden = true
        makeOfferWidthConstraint.constant = isMyItem ? 0 : bottomContainerView.frame.width * 0.5
        bottomContainerView.addShadow(offset: CGSize(width: 2, height: 2), color: .gray, radius: 5, opacity: 0.5)
        var infoImage = UIImage(named: "more")?.rotateImage(degrees: CGFloat(Double.pi/2))
        infoImage = infoImage?.imageWithColor(.white)
        profilePic.makeRoundCorner(25)
        moreButton.setImage(infoImage, for: .normal)
        makeOfferButton.addTarget(self, action: #selector(makeOfferButtonAction(_:)), for: .touchUpInside)
        tableProductDetail.register(UINib(nibName: ReuseIdentifier.tableCellProductDetail, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.tableCellProductDetail)
        tableProductDetail.register(UINib(nibName: ReuseIdentifier.tableCellItemDetail, bundle: nil), forCellReuseIdentifier: ReuseIdentifier.tableCellItemDetail)
        tableProductDetail.register(UINib(nibName: ReuseIdentifier.tableCellShare, bundle:  nil), forCellReuseIdentifier: ReuseIdentifier.tableCellShare)
        tableProductDetail.register(UINib(nibName: ReuseIdentifier.CarDetailCell, bundle:  nil), forCellReuseIdentifier: ReuseIdentifier.CarDetailCell)
        tableProductDetail.register(UINib(nibName: ReuseIdentifier.PropertyDetailCell, bundle:  nil), forCellReuseIdentifier: ReuseIdentifier.PropertyDetailCell)
        tableProductDetail.register(SingleButtonTableCell.self, forCellReuseIdentifier: ReuseIdentifier.SingleButtonTableCell)
        tableProductDetail.register(SingleCollectionViewCell.self, forCellReuseIdentifier: ReuseIdentifier.SingleCollectionViewCell)
        tableProductDetail.register(CommentTableCell.self, forCellReuseIdentifier: ReuseIdentifier.CommentTableCell)
        tableProductDetail.register(CommentListCell.self, forCellReuseIdentifier: ReuseIdentifier.CommentListCell)
        tableProductDetail.register(MeetupLocationCell.self, forCellReuseIdentifier: ReuseIdentifier.MeetupLocationCell)
        tableProductDetail.isHidden = true
        view.layoutIfNeeded()
    }
    
    @IBAction func buttonTappedBack(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func makeOfferButtonAction(_ sender: UIButton) {
        if let makeOfferView = Bundle.main.loadNibNamed(ReuseIdentifier.MakeOfferView, owner: self, options: nil)?.first as? MakeOfferView {
            makeOfferView.frame = view.frame
            makeOfferView.delegate = self
            makeOfferView.userOffer = Double.getDouble(productDetail?.data?.additional_info?.min_price)
            makeOfferView.priceField.text = String.getString(productDetail?.data?.price)
            view.addSubview(makeOfferView)
            delay(time: 0.1) {
                makeOfferView.animateView(isAnimate: true)
            }
        }
    }
    
    @IBAction func chatButtonAction(_ sender: Any) {
        goToChatVC(offerPrice: "")
    }
    
    func goToChatVC(offerPrice: String) {
        if isMyItem {
            let vc = InboxVC.instantiate(fromAppStoryboard: .chat)
            vc.itemId = itemId
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let otherUserId = String.getString(productDetail?.data?.user_id)
            let username = productDetail?.data?.username ?? ""
            let profile_pic = productDetail?.data?.profile_pic ?? ""
            let created_at = Utilities.sharedUtilities.getTimeDifference(dateString: productDetail?.data?.created_at ?? "", isFullFormat: true)
            let product_name = productDetail?.data?.name ?? ""
            let product_pic = (productDetail?.data?.items_image?.count ?? 0) > 0 ? (productDetail?.data?.items_image![0].url ?? "") : ""
            let price = String.getString(productDetail?.data?.price)
            let minPrice = String.getString(productDetail?.data?.additional_info?.min_price)
            let maxPrice = String.getString(productDetail?.data?.additional_info?.max_price)
            let item_id = String.getString(productDetail?.data?.id)
            
            let info = ["item_id": item_id,
                        "otherUserId": otherUserId ,
                        "username":username,
                        "profile_pic":profile_pic,
                        "product_name":product_name,
                        "product_pic":product_pic,
                        "price":price,
                        "created_at":created_at,
                        "min_price": minPrice,
                        "max_price": maxPrice]
            
            let chatVC = ChatVC.instantiate(fromAppStoryboard: .chat)
            
            //If itemSold is 1 it means this item has been sold, now no more offer can be made on this item.
            if !isMyItem, let isItemSold = productDetail?.data?.is_sold, let offerMade = productDetail?.data?.make_offer {
                if isItemSold == 1 && offerMade {
                    chatVC.offerStatusType = .itemSoldToMe //This means item is sold to me
                } else if isItemSold == 0 {
                    if offerMade {
                        chatVC.offerStatusType = .offerMade //Offer is Made but not sold
                    } else {
                        chatVC.offerStatusType = .noActionPerform //No Action Performed
                    }
                } else {
                    chatVC.offerStatusType = .itemSoldToOther //Item is sold to others
                }
            }
            if offerPrice.count > 0 {
                chatVC.offerFromProductVC = offerPrice
            }
            chatVC.info = info
            chatVC.isMyItem = isMyItem
            chatVC.itemType = itemType
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
        }
    }
    
    @IBAction func userProfileButton(_ sender: UIButton) {
        if String.getString(productDetail?.data?.user_id) == Constants.sharedUserDefaults.getUserId() {
            
        } else if String.getString(productDetail?.data?.user_id).count > 0 {
            let profileVC = OtherUserProfileVC()
            profileVC.userId = String.getString(productDetail?.data?.user_id)
            profileVC.userName = productDetail?.data?.username ?? "Profile"
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    @IBAction func moreButtonAction(_ sender: UIButton) {
        let alertController = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        let shareItem = UIAlertAction(title: Titles.share, style: .default) { (action) in
            Utilities.share(content: "https://itunes.apple.com/in/app/divya-bhaskar-for-iphone/id782332038?mt=8", controller: self, subjectLine: "Check the Item")
        }
        
        let editItem = UIAlertAction(title: Titles.editListing, style: .default) { (action) in
            let vc = AddDetailVC.instantiate(fromAppStoryboard: .categories)
            vc.isEdit = true
            if let photoAsset = self.productDetail?.data?.items_image , photoAsset.count > 0 {
                for (index, asset) in photoAsset.enumerated() {
                    vc.photoAsset.append(Photos(selectedIndex: false, assest: nil, count: index, indexPath: IndexPath(row: index, section: 0), imageUrl: asset.url, imageId: asset.item_id))
                }
            }
            vc.itemType = self.itemType
            vc.setData(productDetail: self.productDetail!.data!)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        let markSold = UIAlertAction(title: Titles.markSold, style: .default) { (action) in
            self.markSold()
        }

        let deleteItem = UIAlertAction(title: Titles.deleteListing, style: .default) { (action) in
            let alertVC = UIAlertController(title: Titles.deleteAlert, message: "Are you sure you want to delete this Item?", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "YES", style: .default, handler: { (action) in
                self.deleteItem()
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
        
        let reportUserAction = UIAlertAction(title: Titles.reportList, style: .default) { (action) in
            let reportView = CustomActionSheet(frame: self.view.frame)
            reportView.initializeSetup()
            reportView.delegate = self
            reportView.titleLabel.text = "Why are you reporting this item?"
            self.view.addSubview(reportView)
            reportView.reports = self.productDetail?.data?.reports ?? []
            reportView.tableView.reloadData()
            self.delay(time: 0.05, completionHandler: {
                reportView.animateView(isAnimate: true)
            })
        }
        
        let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel, handler: nil)
        alertController.addAction(shareItem)
        
        if isItemSold {
            alertController.addAction(deleteItem)
        } else if Constants.sharedUserDefaults.getUserId() == String.getString(productDetail?.data?.user_id) {
            alertController.addAction(editItem)
            alertController.addAction(markSold)
            alertController.addAction(deleteItem)
        } else {
            alertController.addAction(reportUserAction)
        }
        
        alertController.addAction(cancelAction)
        alertController.view.tintColor = .darkGray
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
