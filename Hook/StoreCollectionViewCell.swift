//
//  StoreCollectionViewCell.swift
//  Hook
//
//  Created by Pansit Wattana on 4/6/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class StoreCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    
    @IBOutlet var stars: [UIImageView]!
    
    public func setStar(rate: Double) {
        print(rate)
        for star in stars {
            if Double(star.tag) >= rate {
                star.image = #imageLiteral(resourceName: "circle")
            }
        }
    }
}
