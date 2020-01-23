//
//  FoodTableViewCell.swift
//  Fridge Tracker
//
//  Created by Nurin Izzati Jafri on 2020/01/19.
//  Copyright © 2020 Nurin Izzati Jafri. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
