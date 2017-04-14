//
//  MenuOrderTableViewCell.swift
//  Hook
//
//  Created by Pansit Wattana on 3/26/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class MenuOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var storeImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    
    var increaseAction: ((UITableViewCell) -> Void)?
    var decreaseAction: ((UITableViewCell) -> Void)?
    
    @IBAction func decreaseTap(_ sender: Any) {
        decreaseAction?(self)
    }
    @IBAction func increaseTap(_ sender: Any) {
        increaseAction?(self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.layer.cornerRadius = 8
        
        
//        decreaseButton.addTarget(self, action: #selector(MenuOrderViewController.decreaseOrder(sender:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
