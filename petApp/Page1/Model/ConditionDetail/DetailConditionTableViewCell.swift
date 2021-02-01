//
//  DetailConditionTableViewCell.swift
//  petApp
//
//  Created by Michael Louis on 20/01/21.
//

import UIKit

class DetailConditionTableViewCell: UITableViewCell {

    @IBOutlet var textField: UITextField!
    @IBOutlet var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
