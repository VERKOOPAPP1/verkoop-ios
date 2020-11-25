//
//  ProductDetailVC+TableView.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 06/02/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

extension ProductDetailVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return productDetail?.data?.comments?.count ?? 0
        } else if section == 2 {
            if let meetup = productDetail?.data?.meet_up , meetup == 1 {
                return 2
            }
            return 1
        } else if section == 1 {
            if itemType == .car || itemType == .property || itemType == .rentals {
                return 2
            }
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.SingleCollectionViewCell, for: indexPath) as? SingleCollectionViewCell else {
                return UITableViewCell()
            }
            cell.collectionView.register(UINib(nibName: ReuseIdentifier.itemsCollectionCell, bundle: nil), forCellWithReuseIdentifier: ReuseIdentifier.itemsCollectionCell)
            cell.collectionView.tag = 10
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            if let count = productDetail?.data?.items_image?.count, count == 1 {
                cell.collectionView.isScrollEnabled = false
            } else {
                cell.collectionView.isScrollEnabled = true
            }
            cell.pageControl.numberOfPages = productDetail?.data?.items_image?.count ?? 0
            customPageControl = cell.pageControl
            advertiseCollectionView = cell.collectionView
            cell.collectionView.reloadData()
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.tableCellItemDetail, for: indexPath)as! TableCellItemDetail
                cell.productNameLabel.text = productDetail?.data?.name                
                cell.CategoryLabel.text = productDetail?.data?.category_name
                
                if itemType == .generic {
                    cell.priceLabel.text = String(format: "R %.2f",productDetail?.data!.price ?? 0.0)
                } else {
                    cell.priceLabel.text = String(format: "R%@ - R%@",productDetail?.data?.additional_info?.min_price ?? "0" ,productDetail?.data?.additional_info?.max_price ?? "0")
                }
                if Constants.sharedUserDefaults.getUserId() != String.getString(productDetail?.data?.user_id) {
                    cell.likeButton.isSelected = (productDetail?.data?.is_like ?? false)
                } else {
                    cell.likeButton.isSelected = true
                }
                cell.likeButton.addTarget(self, action: #selector(likeButtonAction(_:)), for: .touchUpInside)
                cell.descriptionLabel.text = productDetail?.data?.description
                cell.likeCountLabel.text = String.getString(productDetail?.data?.items_like_count)
                cell.productTypeLabel.text = Int.getInt(productDetail?.data?.item_type) == 1 ? "New" : "Used"
                cell.timeLabel.text = Utilities.sharedUtilities.getTimeDifference(dateString: productDetail?.data?.created_at ?? "")
                
                if itemType == .car || itemType == .property || itemType == .rentals {
                    cell.newUsedImageView.isHidden = true
                    cell.heightConstraint.constant = 0
                    cell.productTypeLabel.isHidden = true
                } else {
                    cell.newUsedImageView.isHidden = false
                    cell.heightConstraint.constant = 15
                    cell.productTypeLabel.isHidden = false
                }
                return cell
            } else {
                if itemType == .car {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.CarDetailCell, for: indexPath) as? CarDetailCell else {
                        return UITableViewCell()
                    }
                    let detail = productDetail?.data?.additional_info
                    cell.registrationLabel.text = (detail?.from_year ?? "") + " - " + (detail?.to_year ?? "")
                    cell.ownerLabel.text = String.getString(detail?.direct_owner) == "1" ? "Private" : "Dealership"
                    if let transmissionType = detail?.transmission_type, transmissionType == "2" {
                        cell.transmissionTypeLabel.text = "Automatic"
                    } else {
                        cell.transmissionTypeLabel.text = "Manual"
                    }
                    cell.brandLabel.text = detail?.brand_name ?? "N.A"
                    cell.modelNameLabel.text = detail?.model_name ?? "N.A"
                    cell.locationLabel.text = detail?.location ?? "N.A"
                    return cell
                } else if itemType == .property || itemType == .rentals {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.PropertyDetailCell, for: indexPath) as? PropertyDetailCell else {
                        return UITableViewCell()
                    }
                    let detail = productDetail?.data?.additional_info
                    if itemType == .rentals, let furnished = detail?.furnished {
                        cell.furnishedTitleLabel.text = "Furnished"
                        cell.furnishedValueLabel.text = furnished == "1" ? "YES" : "NO"
                        cell.bedroomTopConstraint.constant = 8
                    } else {
                        cell.bedroomTopConstraint.constant = 0
                        cell.furnishedTitleLabel.text = ""
                        cell.furnishedValueLabel.text = ""
                    }
                    cell.streetLabel.text = detail?.street_name ?? "N.A"
                    cell.zoneLabel.text = detail?.location ?? "N.A"
                    cell.postalCodeLabel.text = detail?.postal_code ?? "N.A"
                    cell.bedroomLabel.text = detail?.bedroom ?? "N.A"
                    cell.bathroomLabel.text = detail?.bathroom ?? "N.A"
                    cell.areaLabel.text = detail?.city ?? "N.A"
                    cell.parkingTypeLabel.text = (detail?.parking_type ?? "") == "1" ? "Parking" : "Garage"
                    cell.propertyTypeLabel.text = detail?.property_type ?? "N.A"
                    return cell
                } else {
                    return UITableViewCell()
                }
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.tableCellShare, for: indexPath)as! TableCellShare
                cell.whatsappShareButton.addTarget(self, action: #selector(whatsappShareButtonAction(_:)), for: .touchUpInside)
                cell.facebookShareButton.addTarget(self, action: #selector(facebookShareButtonAction(_:)), for: .touchUpInside)
                cell.defaultShareButton.addTarget(self, action: #selector(defaultShareButtonAction(_:)), for: .touchUpInside)
                return cell

            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.MeetupLocationCell, for: indexPath) as? MeetupLocationCell else {
                    return UITableViewCell()
                }
                cell.detailAddressLabel.text = productDetail?.data?.address
                return cell
            }
        } else if indexPath.section == 3 {
            let cell = tableProductDetail.dequeueReusableCell(withIdentifier: ReuseIdentifier.CommentTableCell, for: indexPath) as! CommentTableCell
            cell.commentButton.addTarget(self, action: #selector(commentButtonAction(_:)), for: .touchUpInside)
            return cell
        } else if indexPath.section == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.CommentListCell, for: indexPath) as? CommentListCell else {
                return UITableViewCell()
            }
            let comment = productDetail?.data?.comments![indexPath.row]
            if comment?.index != nil {
                let index = comment?.index
                productDetail?.data?.comments![indexPath.row].index = index
            } else {
                productDetail?.data?.comments![indexPath.row].index = indexPath.row
            }
            if let url = URL(string: API.assetsUrl + String.getString(comment?.profile_pic)) {
                cell.profileImage.kf.setImage(with: url, placeholder: UIImage(named: "pic_placeholder"))
            } else {
                cell.profileImage.image = UIImage(named: "pic_placeholder")
            }
            cell.nameLabel.text = comment?.username
            cell.commentLabel.text = comment?.comment
            cell.timeLabel.text = Utilities.sharedUtilities.getTimeDifference(dateString: comment?.created_at ?? "", isFullFormat: true)            
            cell.deleteButton.tag = Int.getInt(comment?.index)
            cell.deleteButton.addTarget(self, action: #selector(deletecommentButtonAction(_:)), for: .touchUpInside)
            if isMyItem || Constants.sharedUserDefaults.getUserId() == String.getString(comment?.user_id) {
                cell.deleteButton.isHidden = false
            } else   {
                cell.deleteButton.isHidden = true
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 1 {
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                UIApplication.shared.open(URL(string: "comgooglemaps://?saddr=&daddr=\(Float((productDetail?.data?.latitude!)!)),\(Float((productDetail?.data?.longitude!)!))&directionsmode=driving")!, options: [:], completionHandler: nil)
            } else {
                let alertVC = UIAlertController(title: kAppName, message: "Google Map is not installed on this iPhone, Do you want to install it?", preferredStyle: .actionSheet)
                let okAction = UIAlertAction(title: "Install", style: .default) { (action) in
                    UIApplication.shared.open(URL(string: "https://itunes.apple.com/app/id585027354?mt=8")!, options: [:], completionHandler: nil)
                }
                let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel)
                alertVC.view.tintColor = .darkGray
                alertVC.addAction(okAction)
                alertVC.addAction(cancelAction)
                present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let _ = productDetail {
//                centerIfNeeded(collectionView: advertiseCollectionView)
            }
//            startTimer()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        timer?.invalidate()
        timer = nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return kScreenHeight * 0.55
        } else if indexPath.section == 1 {
            return UITableView.automaticDimension
        } else if indexPath.section == 2 {
            return indexPath.row == 0 ? 60 : UITableView.automaticDimension
        } else if indexPath.section == 3 {
            return 55
        } else if indexPath.section == 4 {
            return UITableView.automaticDimension
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return 100
        } else {
            return 60
        }
    }
    
    @objc func commentButtonAction(_ sender: UIButton) {
        Constants.sharedAppDelegate.setSwipe(enabled: false, navigationController: navigationController)
        let reportView = PostCommentView(frame: self.view.frame)
        reportView.initializeSetup()
        reportView.delegate = self
        self.view.addSubview(reportView)
        reportView.animateView(isAnimate: true)
    }
    
    @objc func deletecommentButtonAction(_ sender: UIButton) {
        
        let alertVC = UIAlertController(title: "Delete Comment" , message: nil, preferredStyle: .actionSheet)
        let deleteButton = UIAlertAction(title: "Delete", style: .default) { (action) in
            let alertVC = UIAlertController(title: "Delete Comment", message: "Are you sure you want to delete this comment?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: Titles.ok, style: .default) { (action) in
                let comment = self.productDetail?.data?.comments![sender.tag]
                let indexPath = IndexPath(row: sender.tag, section: 4)
                self.requestDeleteComment(commentId: String.getString(comment?.id), indexPath: indexPath)
            }
            let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel)
            alertVC.view.tintColor = .darkGray
            alertVC.addAction(okAction)
            alertVC.addAction(cancelAction)
            self.present(alertVC, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel)
        alertVC.view.tintColor = .darkGray
        alertVC.addAction(deleteButton)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc func whatsappShareButtonAction(_ sender: UIButton) {
        Console.log(Utilities.shareOnWhatsApp(productDetail?.data?.items_image?.first?.url ?? ""))
    }
    
    @objc func facebookShareButtonAction(_ sender: UIButton) {
        showShareDialog(shareString: API.assetsUrl + (productDetail?.data?.items_image?.first?.url ?? ""))
    }
    
    @objc func defaultShareButtonAction(_ sender: UIButton) {
        Utilities.share(content: productDetail?.data?.items_image?.first?.url ?? "", controller: self, subjectLine: "Check the Verkoop App")
    }
    
    @objc func likeButtonAction(_ sender: UIButton) {
        if Constants.sharedUserDefaults.getUserId() != String.getString(productDetail?.data?.user_id) {
            if sender.isSelected {
                dislikeCategory(params: ["like_id":String.getString(productDetail?.data?.like_id)])
            } else {
                let param = ["user_id" : Constants.sharedUserDefaults.getUserId(), "item_id": itemId]
                likeCategory(params: param )
            }
        }
    }
}
