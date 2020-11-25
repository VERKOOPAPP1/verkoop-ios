//
//  PaymentVC+WebViewDelegates.swift
//  Verkoop
//
//  Created by Vijay on 18/06/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Stripe

extension PaymentVC: STPAddCardViewControllerDelegate {
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
//        Console.log(paymentMethod.allResponseFields)
//        Console.log(paymentMethod.billingDetails)
//        Console.log(paymentMethod.stripeId)
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        dismiss(animated: true)
        let _ = "Transaction success! jjj\n\nHere is the Token: \(token.tokenId)\nCard Type: \(token.card!.funding.rawValue)\n\nSend this token or detail to your backend server to complete this payment."
    }
}

//sk_live_VLEH1pB5b8tEKWAqD5Tdca6T00CEJiIdPR

//pk_live_0QE5t1AQdS0YOx0xAzfzd8Dq00AYl5mZ6X


//sk_test_rsW8QSvzcnZ7pQEOBEel4RpR003CNihQSX
//pk_test_pKPGvdBuMCf4sk2TNYu82IoD00DTN67NYA
