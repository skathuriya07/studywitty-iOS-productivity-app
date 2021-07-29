//
//  UIButton+alignment.swift
//  ShreyaKathuriya-A3-iOs
//
//  Created by admin on 29/05/21.
//

import UIKit

extension UIButton {

    func centerButtonContent(_ spacing: CGFloat) {
        let insetSpacing = spacing/2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetSpacing, bottom: 0, right: insetSpacing)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetSpacing, bottom: 0, right: -insetSpacing)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetSpacing, bottom: 0, right: insetSpacing)
    }
}
