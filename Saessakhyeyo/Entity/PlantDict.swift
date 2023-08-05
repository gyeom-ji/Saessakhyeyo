//
//  PlantDict.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/02.
//

import Foundation

struct Dict: Codable {
    var id : Int
    var waterValue:Float
    var waterRec:String
    var plantName : String
    var dType : String
    var idFromEachDict : Int
    var imgUrl : String
    
    private enum CodingKeys: String, CodingKey {
        
        case id
        case waterValue
        case waterRec
        case plantName
        case dType = "dtype"
        case idFromEachDict = "idFromEachDict"
        case imgUrl
    }
    
    init(){
        id = -1
        waterValue = 0.0
        waterRec = ""
        plantName = ""
        dType = ""
        idFromEachDict = -1
        imgUrl = ""
    }
    
    init(id: Int, waterValue: Float, waterRec:String, plantName : String, dType : String, idFromEachDict : Int, imgUrl : String){
        self.id = id
        self.waterValue = waterValue
        self.waterRec = waterRec
        self.plantName = plantName
        self.dType = dType
        self.idFromEachDict = idFromEachDict
        self.imgUrl = imgUrl
    }
}

struct PlantDict1: Codable {
    var id : Int
    var contentsNo : Int
    var plantEngName : String
    var plantName : String
    var growthHg : Int
    var growthAra: Int
    var manageLevel: String
    var winterMinTemp: String
    var humidity: String
    var fertilizer: String
    var soilInfo: String
    var waterCycleSpring: String
    var waterCycleSummer: String
    var waterCycleAutumn: String
    var waterCycleWinter: String
    var speclManageInfo: String
    var prpgtMth: String
    var lightDemand: String
    var pest: String
    var imgUrl: String
    
    init(){
        id = -1
        contentsNo = -1
        plantEngName = ""
        plantName = ""
        growthHg = -1
        growthAra = -1
        manageLevel = ""
        winterMinTemp = ""
        humidity = ""
        fertilizer = ""
        soilInfo = ""
        waterCycleSpring = ""
        waterCycleSummer = ""
        waterCycleAutumn = ""
        waterCycleWinter = ""
        speclManageInfo = ""
        prpgtMth = ""
        lightDemand = ""
        pest = ""
        imgUrl = ""
    }
    
    init(id : Int, contentsNo : Int, plantEngName : String, plantName : String, growthHg : Int, growthAra: Int, manageLevel: String, winterMinTemp: String, humidity: String, fertilizer: String, soilInfo: String, waterCycleSpring: String, waterCycleSummer: String, waterCycleAutumn: String, waterCycleWinter: String, speclManageInfo: String, prpgtMth: String, lightDemand: String, pest: String, imgUrl: String){
        self.id = id
        self.contentsNo = contentsNo
        self.plantEngName = plantEngName
        self.plantName = plantName
        self.growthHg = growthHg
        self.growthAra = growthAra
        self.manageLevel = manageLevel
        self.winterMinTemp = winterMinTemp
        self.humidity = humidity
        self.fertilizer = fertilizer
        self.soilInfo = soilInfo
        self.waterCycleSpring = waterCycleSpring
        self.waterCycleSummer = waterCycleSummer
        self.waterCycleAutumn = waterCycleAutumn
        self.waterCycleWinter = waterCycleWinter
        self.speclManageInfo = speclManageInfo
        self.prpgtMth = prpgtMth
        self.lightDemand = lightDemand
        self.pest = pest
        self.imgUrl = imgUrl
    }
}

struct PlantDict2: Codable {
    var id : Int
    var contentsNo : Int
    var plantName : String
    var growthInfo : String
    var growthSpeed : String
    var winterMinTemp : String
    var character : String
    var lightDemand : String
    var waterCycle : String
    var prpgtMth : String
    var pest : String
    var manageLevel : String
    var batchPlace : String
    var tip : String
    var imgUrl : String
    var imgUrl2 : String
    
    init(){
        id = -1
        contentsNo = -1
        plantName = ""
        growthInfo = ""
        growthSpeed = ""
        winterMinTemp = ""
        character = ""
        lightDemand = ""
        waterCycle = ""
        prpgtMth = ""
        pest = ""
        manageLevel = ""
        batchPlace = ""
        tip = ""
        imgUrl = ""
        imgUrl2 = ""
    }
    
    init(id : Int, contentsNo : Int, plantName : String, growthInfo : String, growthSpeed : String, winterMinTemp : String, character : String, lightDemand : String, waterCycle : String, prpgtMth : String, pest : String, manageLevel : String, batchPlace : String, tip : String, imgUrl : String, imgUrl2 : String){
        self.id = id
        self.contentsNo = contentsNo
        self.plantName = plantName
        self.growthInfo = growthInfo
        self.growthSpeed = growthSpeed
        self.winterMinTemp = winterMinTemp
        self.character = character
        self.lightDemand = lightDemand
        self.waterCycle = waterCycle
        self.prpgtMth = prpgtMth
        self.pest = pest
        self.manageLevel = manageLevel
        self.batchPlace = batchPlace
        self.tip = tip
        self.imgUrl = imgUrl
        self.imgUrl2 = imgUrl2
    }
}

struct PlantDict3: Codable {
    var id: Int
    var plantName: String
    var sowingSeason: String
    var hvtSeason: String
    var character: String
    var cultInfo: String
    var imgUrl: String
    
    init(){
        id = -1
        plantName = ""
        sowingSeason = ""
        hvtSeason = ""
        character = ""
        cultInfo = ""
        imgUrl = ""
    }
    
    init( id: Int, plantName: String, sowingSeason: String, hvtSeason: String, character: String, cultInfo: String, imgUrl: String){
        self.id = id
        self.plantName = plantName
        self.sowingSeason = sowingSeason
        self.hvtSeason = hvtSeason
        self.character = character
        self.cultInfo = cultInfo
        self.imgUrl = imgUrl
    }
}

struct SectionDict{
    var title: String
    var dict: [Dict]
    
    init (title: String, dict: [Dict]) {
        self.title = title
        self.dict = dict
    }
}
