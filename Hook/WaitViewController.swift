//
//  WaitViewController.swift
//  Hook
//
//  Created by Pansit Wattana on 1/31/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import UIKit

class WaitViewController: UIViewController {

    @IBOutlet weak var hookWaitImage: UIImageView!
    
    var timer = Timer()
    
    var hookImageNameSet = [#imageLiteral(resourceName: "hook_sleep_mid"), #imageLiteral(resourceName: "hook_sleep_right"), #imageLiteral(resourceName: "hook_sleep_mid"), #imageLiteral(resourceName: "hook_sleep_left")]
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(WaitViewController.animate), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animate() {
        index += 1
        if index >= hookImageNameSet.count{
            index = 0
        }
        hookWaitImage.image = hookImageNameSet[index]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
