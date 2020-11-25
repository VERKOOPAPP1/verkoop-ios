//
//  ProfileVC+TableViewDelegates.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 26/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation
import UIKit

extension SettingVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSection.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == tableView.numberOfSections - 1 {
            return nil
        }
        let headerView =  UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        headerView.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 10, y: 2, width: tableView.frame.width - 20, height: 50))
        label.textColor = UIColor.darkGray
        label.font = UIFont.kAppDefaultFontBold(ofSize: 18.0)
        label.backgroundColor = UIColor.white
        label.text = tableSection[section]
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == tableView.numberOfSections - 1 ? CGFloat.leastNormalMagnitude : 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return firstSectionData.count
        }
        else if section == 1 {
            return secondSectionData.count
        }
        else if section == 2 {
            return thirdSectionData.count
        } else {
            return fourthSectionData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.SingleLabelCell, for: indexPath) as? SingleLabelCell else {
            return UITableViewCell()
        }
        
        cell.title.font = UIFont.kAppDefaultFontRegular(ofSize: 17)
        if indexPath.section == 0 {
            cell.title.text = firstSectionData[indexPath.row]
        } else if indexPath.section == 1 {
            cell.title.text = secondSectionData[indexPath.row]
        } else if indexPath.section == 2 {
            cell.title.text = thirdSectionData[indexPath.row]
        } else if indexPath.section == 3 {
            cell.title.text = fourthSectionData[indexPath.row]
            if indexPath.row == 1 {
                cell.title.font = UIFont.kAppDefaultFontBold(ofSize: 17)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let editProfileVC = EditProfileVC.instantiate(fromAppStoryboard: .profile)
                navigationController?.pushViewController(editProfileVC, animated: true)
            } else if indexPath.row == 1 {
                if let passwordView = Bundle.main.loadNibNamed(ReuseIdentifier.ChangePasswordView, owner: self, options: nil)?.first as? ChangePasswordView {
                    passwordView.delegate = self
                    passwordView.frame = view.frame                    
                    view.addSubview(passwordView)
                    showView(animate: true, animatingView: passwordView)
                    Constants.sharedAppDelegate.setSwipe(enabled: false, navigationController: navigationController)
                }
            } else if indexPath.row == 2 {
                let vc = NotificationVC.instantiate(fromAppStoryboard: .profile)
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else if indexPath.row == 3 {
                loadWebView(headerTitle: "Data & Privacy Setting", urlString: sectionArray[indexPath.section][indexPath.row])
            }
        case 1:
            if indexPath.row == 0 {
                loadWebView(headerTitle: "Help Center", urlString: sectionArray[indexPath.section][indexPath.row])
            } else if indexPath.row == 1 {
                loadWebView(headerTitle: "Contact Us", urlString: sectionArray[indexPath.section][indexPath.row])
            } else if indexPath.row == 2 {
                loadWebView(headerTitle: "About Verkoop", urlString: sectionArray[indexPath.section][indexPath.row])
            }
        case 2:
            if indexPath.row == 0 {
                loadWebView(headerTitle: "Terms of Service", urlString: sectionArray[indexPath.section][indexPath.row])
            } else if indexPath.row == 1 {
                loadWebView(headerTitle: "Privacy Policy", urlString: sectionArray[indexPath.section][indexPath.row])
            } else if indexPath.row == 2 {
                let alertVC = UIAlertController(title: "Deactivate", message: "Are you sure you want to deactivate your account?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: Titles.ok, style: .default) { (action) in
                    Constants.sharedAppDelegate.deactivateAccountService()
                }
                let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel)
                alertVC.view.tintColor = .darkGray
                alertVC.addAction(okAction)
                alertVC.addAction(cancelAction)
                DispatchQueue.main.async {
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        default:
            if indexPath.row == 0 {
                let bannerVC = BannerListVC.instantiate(fromAppStoryboard: .advertisement)
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(bannerVC, animated: true)
                }
            } else {
                let alertVC = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: Titles.ok, style: .default) { (action) in
                    Constants.sharedAppDelegate.logoutService()
                }
                let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel)
                alertVC.view.tintColor = .darkGray
                alertVC.addAction(okAction)
                alertVC.addAction(cancelAction)
                DispatchQueue.main.async {
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func showView(animate: Bool, animatingView: ChangePasswordView) {
        if animate == true {
            animatingView.containerView.alpha = 0.0
            animatingView.containerView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            UIView.animate(withDuration: 0.3, animations: {
                animatingView.containerView.transform = CGAffineTransform.identity
                animatingView.containerView.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                animatingView.containerView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                animatingView.containerView.alpha = 0.0
            }, completion: { (status) in
                animatingView.delegate = nil
                animatingView.removeFromSuperview()
            })
        }
    }
    
    func loadWebView(headerTitle: String, urlString: String) {
        let webViewVC = WebViewVC()
        webViewVC.headerTitle = headerTitle
        webViewVC.urlString = urlString
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(webViewVC, animated: true)
        }
    }
}

