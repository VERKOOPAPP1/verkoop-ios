//
//  WalletVC+Protocol.swift
//  Verkoop
//
//  Created by Vijay on 29/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Stripe
import Alamofire

extension WalletVC: STPAddCardViewControllerDelegate, STPPaymentContextDelegate {
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        Console.log("Hello")
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if let card = paymentContext.selectedPaymentMethod as? STPCard {
            let _ = card.stripeID
            // store token as required
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        Console.log("Hello")
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        Console.log("Hello")
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        addMoneyToWallet(amount: amount, token: token.tokenId)
        dismiss(animated: true)
    }
    
    func addMoneyTemp() {
        Loader.show()
        delay(time: 3.0) {
            Loader.hide()
            let oldAmount = Int.getInt(self.transactionHistory?.amount)
            let newAmount = oldAmount + Int.getInt(self.amount)
            self.transactionHistory?.amount = newAmount
        }
    }
}

extension WalletVC: AddMoneyDelegate, PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 11.0, *)
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        STPAPIClient.shared().createToken(with: payment) { (stripeToken, error) in
            guard error == nil, let stripeToken = stripeToken else {
                debugPrint(error!)
                return
            }
            debugPrint(stripeToken)
        }
    }
    
    func didMoneyAdded(amount: String) {
        self.amount = amount
        let alertVC = UIAlertController(title: "Payment", message: "Make Payment", preferredStyle: .actionSheet)
        let viaApplePay = UIAlertAction(title: "Apple Pay", style: .default) { (action) in
            self.payViaApple()
        }
        let viaCard = UIAlertAction(title: "Card Payment", style: .default) { [weak self](action) in
            let addCardViewController = STPAddCardViewController()
            addCardViewController.delegate = self
            
            let navigationController = UINavigationController(rootViewController: addCardViewController)
            self?.present(navigationController, animated: true)
        }
        let cancelAction = UIAlertAction(title: Titles.cancel, style: .cancel, handler: nil)
        let paymentNetworks:[PKPaymentNetwork] = [.amex, .masterCard, .visa, .masterCard]
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            alertVC.addAction(viaApplePay)
        }
        alertVC.addAction(viaCard)
        alertVC.addAction(cancelAction)
        alertVC.view.tintColor = .darkGray
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func payViaApple() {
        let paymentNetworks:[PKPaymentNetwork] = [.amex, .masterCard, .visa, .masterCard]
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()
            request.merchantIdentifier = "merchant.verkoop.com"
            request.countryCode = "ZA"
            request.currencyCode = "ZAR"
            request.supportedNetworks = paymentNetworks            
            if #available(iOS 11.0, *) {
                request.requiredShippingContactFields = [.name, .postalAddress]
            } else {
                // Fallback on earlier versions
            }
            request.merchantCapabilities = .capability3DS
            
            let walletMoney = PKPaymentSummaryItem(label: "Wallet Recharge", amount: NSDecimalNumber(decimal:Decimal(Double.getDouble(amount))), type: .final)
            let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(decimal:Decimal(Double.getDouble(amount))), type: .final)
            request.paymentSummaryItems = [walletMoney, total]
            
            let authorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: request)
            
            if let viewController = authorizationViewController {
                viewController.delegate = self
                DispatchQueue.main.async {
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        } else {
            
        }
    }
}

//func handleApplePayButtonTapped() {
//    let merchantIdentifier = "merchant.com.your_app_name"
//    let paymentRequest = Stripe.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "US", currency: "USD")
//
//    // Configure the line items on the payment request
//    paymentRequest.paymentSummaryItems = [
//        PKPaymentSummaryItem(label: "Fancy Hat", amount: 50.00),
//        // The final line should represent your company;
//        // it'll be prepended with the word "Pay" (i.e. "Pay iHats, Inc $50")
//        PKPaymentSummaryItem(label: "iHats, Inc", amount: 50.00),
//     ]
//
//    if Stripe.canSubmitPaymentRequest(paymentRequest),
//        let paymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
//        paymentAuthorizationViewController.delegate = self
//        present(paymentAuthorizationViewController, animated: true)
//    } else {
//        // There is a problem with your Apple Pay configuration
//    }
//}
//
//extension WalletVC: STPAuthenticationContext {
//    func authenticationPresentingViewController() -> UIViewController {
//        return self
//    }

//    @available(iOS 11.0, *)
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        // Convert the PKPayment into a PaymentMethod
//        STPAPIClient.shared().createPaymentMethod(with: payment) { (paymentMethod: STPPaymentMethod?, error: Error?) in
//            guard let paymentMethod = paymentMethod, error == nil else {
//                // Present error to customer...
//                return
//            }
//            let clientSecret = "client secret of the PaymentIntent created at the beginning of the checkout flow"
//            let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
//            paymentIntentParams.paymentMethodId = paymentMethod.stripeId
//
//            // Confirm the PaymentIntent with the payment method
//            STPPaymentHandler.shared().confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
//                switch (status) {
//                case .succeeded:
//                    // Save payment success
//                    self.paymentSucceeded = true
//                    handler(PKPaymentAuthorizationResult(status: .success, errors: nil))
//                case .canceled:
//                    handler(PKPaymentAuthorizationResult(status: .failure, errors: nil))
//                case .failed:
//                    // Save/handle error
//                    let errors = [STPAPIClient.pkPaymentError(forStripeError: error)].compactMap({ $0 })
//                    handler(PKPaymentAuthorizationResult(status: .failure, errors: errors))
//                @unknown default:
//                    handler(PKPaymentAuthorizationResult(status: .failure, errors: nil))
//                }
//            }
//        }
//    }
//}
