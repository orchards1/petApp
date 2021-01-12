//
//  EditTableViewCell.swift
//  petApp
//
//  Created by Michael Louis on 12/01/21.
//

import UIKit

class EditTableViewCell: UITableViewCell {
    @IBOutlet weak var valueLabel: UITextField!
    @IBOutlet weak var leftLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
