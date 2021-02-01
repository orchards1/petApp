//
//  ModalCornerRadius.swift
//  petApp
//
//  Created by Michael Louis on 23/01/21.
//

import UIKit

class ModalCornerRadius: UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
       }
    override func layoutSubviews() {
            super.layoutSubviews()

            self.roundCorners([.topLeft, .topRight], radius: 30)
        }
}
