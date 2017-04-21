//
//  Feedback.swift
//  Hook
//
//  Created by Pansit Wattana on 4/19/17.
//  Copyright © 2017 Pansit Wattana. All rights reserved.
//

import Foundation
import Alamofire

class Feedback {
    var msg: String = ""
    var rate: Int = 1
    var store_id: Int = -1
    var sender: String = "Guest"
    var subject: String = "Comment"
    
    init(msg: String, rate: Int, store_id: Int, sender: String, subject: String) {
        self.msg = msg
        self.rate = rate
        self.store_id = store_id
        self.sender = sender
        self.subject = subject
    }
    
    func getParam() -> Parameters {
        let param: Parameters = [
            "Rate" : rate,
            "Receiver" : store_id,
            "Sender": sender,
            "Subject": subject,
            "Type" : 0
        ]
        return param
    }
//    "Detail": "อาหารอร่อยมาก",
//           "Rate": 4,
//           "Receiver": 4,
//           "Sender": "HSjRqk2ClfbaKpQSGzpUgiI1gV52",
//           "Subject": "TestAdd",
//           "Type": 0   ← FeedbackStatus
}
