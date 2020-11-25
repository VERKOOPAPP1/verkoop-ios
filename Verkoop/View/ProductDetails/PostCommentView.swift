//
//  PostCommentView.swift
//  Verkoop
//
//  Created by Vijay on 08/04/19.
//  Copyright © 2019 MobileCoderz. All rights reserved.
//

import UIKit

@objc protocol PostCommentDelegates {
    @objc optional func requestPostComment(comment: String)
}

class PostCommentView: UIView {
    
    let blurView : UIView = {
        $0.backgroundColor = .black
        $0.alpha = 0.0
        return $0
    }(UIView())
    
    let containerView : UIView = {
        $0.backgroundColor = UIColor(hexString: "#E6E6E6")
        $0.clipsToBounds = true
        return $0
    }(UIView())

    let lineView : UIView = {
        $0.backgroundColor = .lightGray
        return $0
    }(UIView())
    
    let titleLabel: UILabel = {
        $0.text = "Post a Comment"
        $0.textColor = kAppDefaultColor
        $0.numberOfLines = 0
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 20)
        return $0
    }(UILabel())

    let cancelButton: UIButton = {
        $0.setImage(UIImage(named: "close"), for: .normal)
        return $0
    }(UIButton())

    let postCommentButton: UIButton = {
        $0.layer.cornerRadius = 22.5
        $0.setTitle("Post", for: .normal)
        $0.titleLabel?.font = UIFont.kAppDefaultFontMedium(ofSize: 16.0)
        $0.setTitleColor(.white, for: .normal)
        return $0
    }(UIButton())

    let textView: UITextView = {
        $0.font = UIFont.kAppDefaultFontBold(ofSize: 18.0)
        $0.textColor = .lightGray
        $0.autocorrectionType = .no
        $0.text = "Type your comment"
        return $0
    }(UITextView())

    var textViewPlaceholder = "Type your comment"
    var delegate: PostCommentDelegates?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        initializeSetup()
    }

    public func initializeSetup() {
        addSubview(blurView)
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(cancelButton)
        containerView.addSubview(textView)
        containerView.addSubview(postCommentButton)
        containerView.addSubview(lineView)
        
        blurView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        containerView.addShadow(offset: CGSize(width: 5, height: 5), color: .black, radius: 10, opacity: 0.7)
        containerView.makeRoundCorner(5)
        containerView.snp.makeConstraints { (make) in
            make.bottom.equalTo(snp.bottom).offset(kScreenHeight * 0.5)
            make.centerX.equalToSuperview()
            make.width.equalTo(kScreenWidth * 0.85)
            make.height.equalTo(kScreenHeight * 0.5)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(containerView.snp.left).offset(12)
            make.top.equalTo(containerView.snp.top).offset(8)
            make.height.greaterThanOrEqualTo(30)
        }

        cancelButton.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
        cancelButton.snp.makeConstraints { (make) in
            make.right.equalTo(containerView.snp.right)
            make.left.equalTo(titleLabel.snp.right).offset(12)
            make.height.equalTo(45)
            make.width.equalTo(45)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        textView.delegate = self
        textView.backgroundColor = .clear
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(containerView.snp.left).offset(16)
            make.right.equalTo(containerView.snp.right).offset(-16)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(5)
            make.right.equalTo(containerView.snp.right).offset(-12)
            make.left.equalTo(containerView.snp.left).offset(12)
            make.height.equalTo(1)
        }
        
        postCommentButton.backgroundColor = kAppDefaultColor
        postCommentButton.setRadius(postCommentButton.frame.height / 2, .white, 3)
        postCommentButton.addTarget(self, action: #selector(submitButtonAction(_:)), for: .touchUpInside)
        postCommentButton.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(containerView.snp.bottom).offset(-8)
            make.width.equalTo(kScreenWidth * 0.35)
            make.height.equalTo(45)
        }
        
        self.layoutIfNeeded()
    }

    public func animateView(isAnimate: Bool = true) {
        if isAnimate {
            containerView.snp.updateConstraints { (make) in
                make.bottom.equalTo(snp.bottom).offset(-(kScreenHeight - self.containerView.frame.height) / 2)
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.blurView.alpha = 0.4
                self.layoutIfNeeded()
            })
        } else {
            containerView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom).offset(kScreenHeight * 0.5)
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.blurView.alpha = 0.0
                self.layoutIfNeeded()
            }) { (status) in
                self.removeFromSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            containerView.snp.makeConstraints { (make) in
                make.bottom.equalTo(snp.bottom).offset(-(kScreenHeight - self.containerView.frame.height) / 2 - keyboardSize.height / 2)
                make.centerX.equalToSuperview()
                make.width.equalTo(kScreenWidth * 0.85)
                make.height.equalTo(kScreenHeight * 0.5)
            }
            UIView.animate(withDuration: 0.25) {
                self.containerView.layoutIfNeeded()
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        containerView.snp.remakeConstraints { (make) in
            make.bottom.equalTo(snp.bottom).offset(-(kScreenHeight - self.containerView.frame.height) / 2)
            make.centerX.equalToSuperview()
            make.width.equalTo(kScreenWidth * 0.85)
            make.height.equalTo(kScreenHeight * 0.5)
        }
        UIView.animate(withDuration: 0.25) {
            self.containerView.layoutIfNeeded()
            self.layoutIfNeeded()
        }
    }
    
    @objc func submitButtonAction(_ sender: UIButton) {
        if let delegateObject = delegate , !textView.text.isEmpty, textView.textColor != .lightGray {
            animateView(isAnimate: false)
            delegateObject.requestPostComment?(comment: textView.text!)
        }
    }

    @objc func cancelButtonAction(_ sender: UIButton) {
        animateView(isAnimate: false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self) else { return }
        if !containerView.frame.contains(location) {
            textView.resignFirstResponder()
        }
    }
}

extension PostCommentView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let text = textView.text {
            if text.isEmpty || text == textViewPlaceholder {
                textView.text = textViewPlaceholder
                textView.textColor = .lightGray
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            } else {
                textView.text = text
                textView.textColor = kAppDefaultColor
            }
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.isEmpty {
            textView.text = textViewPlaceholder
            textView.textColor = .lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == .lightGray && !text.isEmpty {
            textView.textColor = kAppDefaultColor
            textView.text = text
        } else {
            return true
        }
        return false
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if let view = self.superview , view.window != nil {
            if textView.textColor == .lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text , !text.isEmpty , text.removingWhitespaces() != textViewPlaceholder.removingWhitespaces() {
        }
    }
}
