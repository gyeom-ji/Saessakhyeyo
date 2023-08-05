//
//  Diary.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/02.
//

import Foundation

struct Diary: Codable {
    var id: Int
    var date: String
    var time: String
    var content: String
    var weather: String
    var cond: String
    var activity1: String
    var activity2: String
    var activity3: String
    var imgData: Data?
    var userId: Int
    var myPlantId: Int
    var isImg: Bool
    var isUpdateImg: Bool

    private enum CodingKeys: String, CodingKey {
        case id
        case date
        case time
        case content
        case weather
        case cond
        case activity1
        case activity2
        case activity3
        case userId = "user_id"
        case myPlantId = "myplant_id"
        case isImg = "img"
        case isUpdateImg = "updateImg"
    }
    
    init(id: Int, date: String, time: String, content: String, weather: String, cond: String, activity1: String, activity2: String, activity3: String, imgData: Data? = nil, userId: Int, myPlantId: Int, isImg: Bool, isUpdateImg: Bool) {
        self.id = id
        self.date = date
        self.time = time
        self.content = content
        self.weather = weather
        self.cond = cond
        self.activity1 = activity1
        self.activity2 = activity2
        self.activity3 = activity3
        self.imgData = imgData
        self.userId = userId
        self.myPlantId = myPlantId
        self.isImg = isImg
        self.isUpdateImg = isUpdateImg
    }
    
    init(){
        self.id = -1
        self.date = ""
        self.time = ""
        self.content = ""
        self.weather = ""
        self.cond = ""
        self.activity1 = ""
        self.activity2 = ""
        self.activity3 = ""
        self.imgData = Data()
        self.userId = 0
        self.myPlantId = 0
        self.isImg = false
        isUpdateImg = true
    }
}
