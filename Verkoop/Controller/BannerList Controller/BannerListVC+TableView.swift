//
//  BannerListVC+TableView.swift
//  Verkoop
//
//  Created by Vijay on 31/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

extension BannerListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionHistory?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  ReuseIdentifier.BannerListCell, for: indexPath) as? BannerListCell else {
            return UITableViewCell()
        }
        cell.renewButton.addTarget(self, action: #selector(renewButtonAction(_:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonAction(_:)), for: .touchUpInside)
        cell.bannerDetail = transactionHistory?.data![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kScreenHeight * 0.4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bannerVC = BannerDetailVC.instantiate(fromAppStoryboard: .advertisement)
        bannerVC.bannerId = String.getString(transactionHistory?.data![indexPath.row].id)
        bannerVC.userId = Constants.sharedUserDefaults.getUserId()
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(bannerVC, animated: true)
        }
    }
    
    @objc func renewButtonAction(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: bannerListTableView)
        if let indexPath = bannerListTableView.indexPathForRow(at: point) {
            let packageVC = SelectPackageVC.instantiate(fromAppStoryboard: .advertisement)
            packageVC.delegate = self
            packageVC.bannerId = String.getString(transactionHistory?.data![indexPath.row].id)
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(packageVC, animated: true)
            }
        }
    }
    
    @objc func deleteButtonAction(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Delete Banner", message: "Are you sure you want to delete?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            let point = sender.convert(CGPoint.zero, to: self.bannerListTableView)
            if let indexPath = self.bannerListTableView.indexPathForRow(at: point) {
                self.deleteBannerService(bannerId: String.getString(self.transactionHistory?.data![indexPath.row].id), indexPath: indexPath)
            }
        }
        let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        alertVC.view.tintColor = .darkGray
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}

extension BannerListVC: RenewBannerDelegate {
    func didBannerRenewed(bannerId: Int) {
        for (index, category) in (transactionHistory?.data!)!.enumerated() {
            if let id = category.id, bannerId == id {
                let indexPath = IndexPath(row: index, section: 0)
                if let cell = bannerListTableView.cellForRow(at: indexPath) as? BannerListCell {
                    transactionHistory?.data![index].status = 1
                    cell.renewButton.alpha = 0.3
                    cell.renewButton.isEnabled = false
                    DispatchQueue.main.async {
                        cell.renewButton.layoutIfNeeded()
                    }
                }
                break
            }
        }
    }
}
