//
//  ChatVC+TextView.swift
//  Verkoop
//
//  Created by Vijay on 08/05/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import Foundation

extension ChatVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 20.0
        paragraphStyle.maximumLineHeight = 35.0
        let dictText = messageTextView.typingAttributes
        var editedDict = dictText
        editedDict[.paragraphStyle] = paragraphStyle
        messageTextView.typingAttributes = editedDict
        return true
    }
}
