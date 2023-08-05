//
//  Notification.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/02.
//

import Foundation

struct Notification: Codable{
    var id: Int
    var dateTime: String
    var userId: Int
    var check: Bool
    var message: String
    var type: String
    
    init(){
        id = -1
        dateTime = ""
        message = ""
        userId = -1
        type = ""
        check = false
    }
    
    init(id:Int, dateTime:String, message:String, userId:Int, type:String, check:Bool){
        self.id = id
        self.dateTime = dateTime
        self.message = message
        self.userId = userId
        self.type = type
        self.check = check
        
    }
}
