//
//  HomeTableViewCell.swift
//  petApp
//
//  Created by Michael Louis on 24/12/20.
//

import UIKit

class HomeTableViewCell: UITableViewCell {    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
       
    }
}
