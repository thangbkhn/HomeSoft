//
//  MyTextField.swift
//  SlidingMenu
//
//  Created by Nguyen Van Tho on 12/18/17.
//  Copyright © 2017 Viettel. All rights reserved.
//

import UIKit

@IBDesignable
class MyTextField: UITextField {
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.blue {
        didSet {
            updateView()
            self.layer.borderColor = GlobalUtil.getMainColor().cgColor
            self.layer.borderWidth = 0.5
            self.layer.cornerRadius = 7
            self.layer.masksToBounds = true
        }
    }
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
            
            imageView.image = image
            
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = .white
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: color])
    }

}
