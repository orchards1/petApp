//
//  addImageCollectionViewCell.swift
//  petApp
//
//  Created by Michael Louis on 27/12/20.
//

import UIKit

class AddImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func addButtonDidTapped(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("addPhoto"), object: nil)
    }
    @IBAction func deleteButtonDidTapped(_ sender: Any) {
        let buttonRow = (sender as AnyObject).tag
        NotificationCenter.default.post(name: Notification.Name("delPhoto"), object: nil,userInfo: buttonRow as? [AnyHashable : Any])
    }
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
}
