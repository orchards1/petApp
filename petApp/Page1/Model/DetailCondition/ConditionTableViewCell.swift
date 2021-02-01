//
//  conditionTableViewCell.swift
//  petApp
//
//  Created by Michael Louis on 14/01/21.
//

import UIKit

class ConditionTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var accessoryButton: UIButton?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        accessoryType = .disclosureIndicator
    }
    override func layoutSubviews() {
           super.layoutSubviews()
        
       }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
