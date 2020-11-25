//
//  UIView+Additions.swift
//  GymClass
//
//  Created by MobileCoderz5 on 8/23/18.
//  Copyright © 2018 MobileCoderz5. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layoutIfNeeded()
    }
    
    func setShadow(radius: CGFloat = 5.0) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 2, height: 5)
    }
    
    func setBottomShadow(radius: CGFloat = 2.0) {
        layer.masksToBounds = false
        layer.cornerRadius = radius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: -1 ,height: +3)
        layer.shadowRadius = radius
    }
    
    func addBlackGradientLayerInForeground(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        layer.addSublayer(gradient)
    }
    
    func addBlackGradientLayerInBackground(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        layer.insertSublayer(gradient, at: 0)
    }
    
    func setRadius(_ corner : CGFloat) {
        layer.cornerRadius = corner
    }
    
    func setRadius(_ corner : CGFloat , _ color : UIColor){
        layer.cornerRadius = corner
        layer.masksToBounds = true
        layer.borderWidth = 3
        layer.borderColor = color.withAlphaComponent(0.5).cgColor
    }
    
    func setShadowToNavigationBar() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 10
    }
    
    func setBottomShadow(shadowRadius: CGFloat, cornerRadius: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: -1 ,height: +3)
        layer.shadowRadius = shadowRadius
    }
    
    func setGradientLinearLeftToRight(colors: [CGColor], gradientFrame: CGRect) {
        layer.sublayers = nil
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientFrame
        gradientLayer.colors = [UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        clipsToBounds = true
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = path.cgPath
        layer.mask = shapeLayer
    }
    
    public enum innerShadowSide {
        case all, left, right, top, bottom, topAndLeft, topAndRight, bottomAndLeft, bottomAndRight, exceptLeft, exceptRight, exceptTop, exceptBottom
    }
    
    // define function to add inner shadow
    public func addInnerShadow(onSide: innerShadowSide, shadowColor: UIColor, shadowSize: CGFloat, cornerRadius: CGFloat = 0.0, shadowOpacity: Float) {
        // define and set a shaow layer
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowSize
        shadowLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        // define shadow path
        let shadowPath = CGMutablePath()
        
        // define outer rectangle to restrict drawing area
        let insetRect = bounds.insetBy(dx: -shadowSize * 2.0, dy: -shadowSize * 2.0)
        
        // define inner rectangle for mask
        let innerFrame: CGRect = { () -> CGRect in
            switch onSide
            {
            case .all:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
            case .left:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .right:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .top:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case.bottom:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndLeft:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndRight:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndLeft:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndRight:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .exceptLeft:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptRight:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptTop:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            case .exceptBottom:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            }
        }()
        
        // add outer and inner rectangle to shadow path
        shadowPath.addRect(insetRect)
        shadowPath.addRect(innerFrame)
        
        // set shadow path as show layer's
        shadowLayer.path = shadowPath
        
        // add shadow layer as a sublayer
        layer.addSublayer(shadowLayer)
        
        // hide outside drawing area
        clipsToBounds = true
    }
    
    func setRadius(_ corner : CGFloat , _ color : UIColor, _ borderWidth: CGFloat) {
        layer.cornerRadius = corner
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = color.cgColor
    }
    
    func makeRounded() {
        layer.cornerRadius = frame.size.width/2.0
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func makeRoundCorner(_ radius:CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
    }
    
    func makeBorder(_ width:CGFloat,color:UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        clipsToBounds = true
    }
}


class SemiCirleView: UIButton {    
    var semiCirleLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if semiCirleLayer == nil {
            let arcCenter = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
            let circleRadius = bounds.size.height / 2
            let circlePath = UIBezierPath()
            
            circlePath.addArc(withCenter: arcCenter, radius: circleRadius, startAngle: CGFloat(deg2rad(90)), endAngle: CGFloat(deg2rad(270)), clockwise: true)
            circlePath.move(to: CGPoint(x: bounds.size.width/2, y: bounds.size.height))
            circlePath.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
            circlePath.addLine(to: CGPoint(x: bounds.size.width, y: 0))
            circlePath.addLine(to: CGPoint(x: bounds.size.width/2, y: 0))
            semiCirleLayer = CAShapeLayer()
            semiCirleLayer.path = circlePath.cgPath
            semiCirleLayer.strokeColor = UIColor.red.cgColor
            semiCirleLayer.fillColor = UIColor.red.cgColor
            layer.addSublayer(semiCirleLayer)
            backgroundColor = UIColor.clear
        }
    }
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
}
