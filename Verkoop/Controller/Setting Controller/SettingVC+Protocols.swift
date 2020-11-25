//
//  SettingVC+Delegates.swift
//  Verkoop
//
//  Created by Vijay's Macbook on 27/03/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

extension SettingVC: ChangePasswordDelegates {
    func cancelChangePassword(view: ChangePasswordView) {
        showView(animate: false, animatingView: view)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
    }
    
    func requestChangePassword(view: ChangePasswordView, param: [String:String]) {
        showView(animate: false, animatingView: view)
        Constants.sharedAppDelegate.setSwipe(enabled: true, navigationController: navigationController)
        let endPoint = MethodName.changePassword
        ApiManager.request(path:endPoint, parameters: param, methodType: .post) { [weak self](result) in
            switch result {
            case .success(let data):
                if let responseData: GenericResponse = self?.handleSuccess(data: data) {
                    DisplayBanner.show(message: responseData.message)
                }
            case .failure(let error):
                self?.handleFailure(error: error)
            case .noDataFound(_):
                break
            }
        }
    }
}
