//
//  circleButton.swift
//  petApp
//
//  Created by Michael Louis on 26/12/20.
//

import UIKit

class circleImage: UIImageView {

    override func awakeFromNib() {

           layer.cornerRadius = 52
           layer.masksToBounds = true
       }

}
