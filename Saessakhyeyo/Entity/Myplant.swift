//
//  Myplant.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/02.
//

import Foundation

struct Myplant: Codable {
    var id: Int
    var userId: Int
    var nickname: String
    var species: String
    var sunCondition: Float
    var windCondition: Float
    var waterCondition: Float
    var waterCycle: Int
    var imgUrl: String
    var isActive: Bool
    var dday: String?
    var tempDate: String
    var icon : String
    var recommendStr: String
    var plantRegionEng: String
    var plantRegionKor: String?
    
    init()
    {
        id = -1
        userId = -1
        nickname = ""
        species = ""
        sunCondition = 0
        windCondition = 0
        waterCondition = 0
        waterCycle = 0
        imgUrl = ""
        isActive = true
        tempDate = ""
        icon = ""
        dday = ""
        plantRegionKor = ""
        recommendStr = ""
        plantRegionEng = ""
    }
    
    private enum CodingKeys: String, CodingKey {
        
        case id
        case userId
        case nickname
        case species
        case sunCondition
        case windCondition
        case waterCondition
        case waterCycle
        case imgUrl
        case isActive
        case tempDate
        case icon
        case recommendStr
        case plantRegionEng = "plantedRegion"
    }
    
    init(id:Int, userId:Int, nickname: String, species: String, sunCondition:Float, windCondition:Float, waterCondition: Float, waterCycle:Int, imgUrl:String, isActive:Bool, tempDate:String, icon : String, recommendStr: String, plantRegionEng: String, dday: String? = ""){
        self.id = id
        self.userId = userId
        self.nickname = nickname
        self.species = species
        self.sunCondition = sunCondition
        self.windCondition = windCondition
        self.waterCondition = waterCondition
        self.waterCycle = waterCycle
        self.imgUrl = imgUrl
        self.isActive = isActive
        self.tempDate = tempDate
        self.icon = icon
        self.recommendStr = recommendStr
        self.plantRegionEng = plantRegionEng
        self.dday = dday
    }
}
