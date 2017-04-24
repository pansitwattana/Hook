//
//  StoreTableViewCell.swift
//  Hook
//
//  Created by Pansit Wattana on 3/29/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var queueLabel: UILabel!
    
    @IBOutlet weak var statusImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
