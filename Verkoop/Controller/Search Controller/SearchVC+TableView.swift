//
//  SearchVC+TableView.swift
//  Verkoop
//
//  Created by Vijay on 09/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchType == .item ? 50 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if searchType == .item {
            let headerView =  UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 50))
            headerView.backgroundColor = UIColor.white
            headerView.clipsToBounds = true
            
            let headerButton = UIButton()
            let imageIcon = UIImageView(image: UIImage(named: "user"))
            let lineView = UIView()
            
            headerView.addSubview(headerButton)
            headerView.addSubview(imageIcon)
            headerView.addSubview(lineView)
            
            imageIcon.contentMode = .scaleAspectFit
            imageIcon.snp.makeConstraints { (make) in
                make.left.equalTo(headerView.snp.left).offset(16)
                make.centerY.equalToSuperview().offset(-2)
                make.height.equalTo(15)
                make.width.equalTo(15)
            }
            
            headerButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            headerButton.contentHorizontalAlignment = .left
            headerButton.setTitle("Search user instead", for: .normal)
            headerButton.setTitleColor(.darkGray, for: .normal)
            headerButton.titleLabel?.font = UIFont.kAppDefaultFontMedium(ofSize: 20)
            headerButton.removeTarget(self, action: #selector(headerButtonAction(_:)), for: .touchUpInside)
            headerButton.addTarget(self, action: #selector(headerButtonAction(_:)), for: .touchUpInside)
            headerButton.snp.makeConstraints { (make) in
                make.left.equalTo(imageIcon.snp.right).offset(12)
                make.right.equalTo(headerView.snp.right).offset(-12)
                make.top.equalTo(headerView.snp.top)
            }
            
            lineView.backgroundColor = .lightGray
            lineView.snp.makeConstraints { (make) in
                make.top.equalTo(headerButton.snp.bottom)
                make.left.equalTo(headerView.snp.left).offset(8)
                make.right.equalTo(headerView.snp.right).offset(-8)
                make.height.equalTo(1)
                make.bottom.equalTo(headerView.snp.bottom)
            }
            
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchType == .imageRecognition {
            return searchedImageData?.data?.item?.count ?? 0
        } else
        if searchType == .item  {
            return searchItemData?.data?.count ?? 0
        } else if searchType == .user || searchType == .follower || searchType == .following {
            return filteredUserData?.data?.count ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchType == .item || searchType == .imageRecognition {
            return 60
        } else {
            return 71
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchType == .imageRecognition {
            
        } else if searchType == .item {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.SearchItemCell, for: indexPath) as? SearchItemCell  else {
                return UITableViewCell()
            }
            
            let user = searchItemData?.data![indexPath.row]
            cell.itemNameLabel.text = user?.name
            cell.itemCategoryLabel.text = user?.category_name
            return cell
            
        } else if searchType == .user || searchType == .follower || searchType == .following {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.SearchedUserCell, for: indexPath) as? SearchedUserCell  else {
                return UITableViewCell()
            }
            let user = filteredUserData?.data![indexPath.row]
            
            if searchType == .follower {
                cell.followButton.isHidden = true
            } else {
                cell.followButton.isHidden = false
            }
            cell.nameLabel.text = user?.username
            cell.profileImage.makeRoundCorner(27.5)
            if let url = URL(string: API.assetsUrl + String.getString(user?.profile_pic)) {
                cell.profileImage.kf.setImage(with: url, placeholder: UIImage(named: "pic_placeholder"))
            } else {
                cell.profileImage.image =  UIImage(named: "pic_placeholder")
            }
            cell.followButton.isSelected = Int.getInt(user?.follower_id) != 0
            cell.followButton.tag = indexPath.row
            cell.followButton.removeTarget(self, action: #selector(followButtonAction(_:)), for: .touchUpInside)
            cell.followButton.addTarget(self, action: #selector(followButtonAction(_:)), for: .touchUpInside)
            cell.layoutIfNeeded()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchType == .item || searchType == .imageRecognition {
            if let item = searchItemData?.data![indexPath.row] {
                DispatchQueue.main.async {
                    let filterVC = CategoriesFilterVC.instantiate(fromAppStoryboard: .categories)
                    filterVC.catgoryId = String.getString(item.category_id)
                    filterVC.categoryName = item.category?.name ?? ""
                    filterVC.type = Int.getInt(item.category?.id) == 0 ? "0" : "1"
                    filterVC.item_id = String.getString(item.id)
                    self.navigationController?.pushViewController(filterVC, animated: true)
                }
            }
        } else if searchType == .user || searchType == .follower || searchType == .following {
            if let user = filteredUserData?.data![indexPath.row] {
                if Constants.sharedUserDefaults.getUserId() != String.getString(user.id) {
                    let profileVC = OtherUserProfileVC()
                    profileVC.userId = String.getString(user.id)
                    profileVC.userName = user.username ?? "Profile"
                    navigationController?.pushViewController(profileVC, animated: true)
                }
            }
        }        
    }
    
    @objc func followButtonAction(_ sender: UIButton) {
        if userId == Constants.sharedUserDefaults.getUserId() && searchType != .follower {
            let indexPath = IndexPath(item: sender.tag, section: 0)
            if let user = filteredUserData?.data![indexPath.row] {
                if sender.isSelected {
                    unfollowUser(id: String.getString(user.follower_id), indexPath: indexPath)
                } else {
                    let param = ["user_id" : Constants.sharedUserDefaults.getUserId(), "follower_id":String.getString(user.id)]
                    followUser(param:param, indexPath: indexPath)
                }
            }
        }
    }
    
    @objc func headerButtonAction(_ sender: UIButton) {
        let searchVC = SearchVC()
        searchVC.searchType = .user
        navigationController?.pushViewController(searchVC, animated: true)
        view.endEditing(true)
    }
}
