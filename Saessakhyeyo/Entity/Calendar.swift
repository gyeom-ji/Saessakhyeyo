//
//  Plan.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/02.
//

import Foundation

struct Plan: Codable{
    var id: Int
    var date: String
    var planType: String
    var myplantId: Int
    var myplantName: String
    var isDone: Bool
    
    init(){
        id = -1
        date = ""
        planType = ""
        myplantId = -1
        myplantName = ""
        isDone = false
    }
    
    init(id:Int, date:String, planType:String, myplantId:Int, myplantName:String, isDone:Bool){
        self.id = id
        self.date = date
        self.planType = planType
        self.myplantId = myplantId
        self.myplantName = myplantName
        self.isDone = isDone
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case date
        case planType
        case myplantId = "myplant_id"
        case myplantName = "myplant_name"
        case isDone = "done"
    }
}

