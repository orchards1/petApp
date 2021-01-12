//
//  cornerRadius.swift
//  petApp
//
//  Created by Michael Louis on 25/12/20.
//

import UIKit

class cornerRadius: UIImageView {

    override func awakeFromNib() {

           layer.cornerRadius = 15
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
           layer.masksToBounds = true
       }
}
