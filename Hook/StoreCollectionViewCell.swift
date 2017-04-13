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
        
        let roundRate = Int(round(rate))
        
        print(roundRate)
        
        if roundRate < stars.count {
            for i in roundRate...stars.count - 1 {
                stars[i].image = #imageLiteral(resourceName: "main_unstar")
            }
        }
    }
}
