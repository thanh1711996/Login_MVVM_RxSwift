//
//  UIView+Extension.swift
//  Login_MVVM_RxSwift
//
//  Created by Mac on 22/04/2021.
//

import Foundation
import UIKit

extension UIView {
    
    // constraint add subview
    func attachView(_ childView: UIView, top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, width: CGFloat = 1.0 ) {
        self.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: childView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: top).isActive = true
        NSLayoutConstraint(item: childView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: bottom).isActive = true
        NSLayoutConstraint(item: childView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: left).isActive = true
        NSLayoutConstraint(item: childView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: width, constant: 0).isActive = true
    }
    
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

protocol textFieldDeleteBackward: class {
    func deleteBackward()
}

class UITextFieldModern: UITextField {
    
    weak var delegateBackward: textFieldDeleteBackward?
    
    override func deleteBackward() {
        super.deleteBackward()
        self.delegateBackward?.deleteBackward()
    }
}
