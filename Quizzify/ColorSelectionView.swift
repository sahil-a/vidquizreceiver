//
//  ColorSelectionView.swift
//  Quizzify
//
//  Created by Sahil Ambardekar on 5/1/16.
//  Copyright © 2016 Sahil Ambardekar. All rights reserved.
//

import UIKit

@IBDesignable class ColorSelectionView: UIView {

    @IBInspectable var selected: Bool = false  {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        self.layer.masksToBounds = true
        self.layer.borderWidth = (selected) ? 4 : 0
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.cornerRadius = self.frame.width / 2
    }
}
