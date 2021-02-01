//
//  AddVaccineTableViewCell.swift
//  petApp
//
//  Created by Michael Louis on 18/01/21.
//

import UIKit

class AddVaccineTableViewCell: UITableViewCell {


    @IBOutlet var label: UILabel!
    @IBAction func buttonDidTapped(_ sender: Any) {
        if(radioButton.isSelected == false)
        {
            self.radioButton.isSelected = true
        }
        else
        {
            self.radioButton.isSelected = false
        }
        
    }
    
    @IBOutlet weak var radioButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
