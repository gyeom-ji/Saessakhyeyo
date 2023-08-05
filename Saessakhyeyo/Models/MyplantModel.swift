//
//  MyplantModel.swift
//  FirstProject
//
//  Created by 윤겸지 on 2022/10/09.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift
import WidgetKit

struct MyplantModel {
    static let shared = MyplantModel()
    
    var regionList = City()
    var myPlant = BehaviorSubject<Myplant>(value: Myplant())
    var isDelete = PublishSubject<Int>()
    var isSort = PublishSubject<Bool>()
    var myPlantList = BehaviorRelay<[Myplant]>(value: [])
    
    var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_kr")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter
    }()
    
    private init(){}
    private let disposeBag = DisposeBag()
    
    func insertMyPlant(userId: Int, myPlant: Myplant)
    {
        let url = APIConstrants.baseURL + "/my-plant"
        
        let headers: Alamofire.HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let body : Parameters = [
            "userId" : userId,
            "nickname" : myPlant.nickname,
            "species" : myPlant.species,
            "sunCondition" : myPlant.sunCondition,
            "windCondition" : myPlant.windCondition,
            "waterCondition" : myPlant.waterCondition,
            "waterCycle" : myPlant.waterCycle,
            "imgUrl" : myPlant.imgUrl,
            "isActive" : myPlant.isActive,
            "tempDate" : myPlant.tempDate,
            "plantedRegion": myPlant.plantRegionEng
        ]
        
        let resource = Resource<Myplant>(url: URL(string: url)!, method: .post, headers: headers, body: body)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                self.myPlant.onNext(result)
                WidgetCenter.shared.reloadTimelines(ofKind: "SaessakMyPlantWidget")
                print(result)
            }).disposed(by: disposeBag)
    }
    
    func readPlantOne(userId: Int, plantId: Int) {
        let url = APIConstrants.baseURL + "/my-plant/\(userId)/\(plantId)"
        
        let headers: Alamofire.HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<Myplant>(url: URL(string: url)!, method: .get, headers: headers)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                
                var tempPlant = result
                
                tempPlant.plantRegionKor = setPlantRegionKor(plantRegionEng: tempPlant.plantRegionEng)
                
                tempPlant.dday = setDday(date: result.tempDate, waterCycle: result.waterCycle)
                
                tempPlant.icon = setIcon(icon: tempPlant.icon)
                
                self.myPlant.onNext(tempPlant)
                
                print(result)
            }).disposed(by: disposeBag)
    }
    
    func readPlantList(userId: Int) {
        let url = APIConstrants.baseURL + "/my-plant/\(userId)"
        
        let headers: Alamofire.HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<[Myplant]>(url: URL(string: url)!, method: .get, headers: headers)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                
                var tempPlantList = result
                
                for i in 0..<tempPlantList.count {
                    
                    tempPlantList[i].plantRegionKor = setPlantRegionKor(plantRegionEng: tempPlantList[i].plantRegionEng)
                    
                    tempPlantList[i].dday = setDday(date: tempPlantList[i].tempDate, waterCycle: tempPlantList[i].waterCycle)
                    
                    tempPlantList[i].icon = setIcon(icon: tempPlantList[i].icon)
                }
                
                self.myPlantList.accept(tempPlantList)
                
                print(tempPlantList)
            }).disposed(by: disposeBag)
    }
    
    func deletePlant(plantId: Int) {
        let url = APIConstrants.baseURL + "/my-plant/\(plantId)"
        
        let headers: Alamofire.HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<Bool>(url: URL(string: url)!, method: .delete, headers: headers)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                self.isDelete.onNext(plantId)
                WidgetCenter.shared.reloadTimelines(ofKind: "SaessakMyPlantWidget")
            }).disposed(by: disposeBag)
    }
    
    func customSortPlant(plantId: Int, order: String) {
        let url = APIConstrants.baseURL + "/my-plant/\(plantId)=\(order)"
        
        let headers: Alamofire.HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<Int>(url: URL(string: url)!, method: .put, headers: headers)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                self.isSort.onNext(true)
            }).disposed(by: disposeBag)
    }
    
    func updatePlantAll(plant: Myplant) {
        let url = APIConstrants.baseURL + "/my-plant/\(plant.id)/all"
        
        let headers: Alamofire.HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let body : Parameters = [
            "id" : plant.id,
            "userId" : plant.userId,
            "nickname" : plant.nickname,
            "species" : plant.species,
            "sunCondition" : plant.sunCondition,
            "windCondition" : plant.windCondition,
            "waterCondition" : plant.waterCondition,
            "waterCycle" : plant.waterCycle,
            "imgUrl" : plant.imgUrl,
            "isActive" : plant.isActive,
            "tempDate" : plant.tempDate,
            "icon" : plant.icon,
            "recommendStr": plant.recommendStr,
            "plantedRegion": plant.plantRegionEng
        ]
        print(body)
        let resource = Resource<Int>(url: URL(string: url)!, method: .put, headers: headers, body: body)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                if result == plant.id {
                    self.myPlant.onNext(plant)
                    WidgetCenter.shared.reloadTimelines(ofKind: "SaessakMyPlantWidget")
                }
            }).disposed(by: disposeBag)
    }
    
    func updatePlant(plantId: Int, type: String) {
        let url = APIConstrants.baseURL + "/my-plant/\(plantId)/\(type)"
        
        let headers: Alamofire.HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<Int>(url: URL(string: url)!, method: .put, headers: headers)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                WidgetCenter.shared.reloadTimelines(ofKind: "SaessakMyPlantWidget")
            }).disposed(by: disposeBag)
    }
    
    func setPlantRegionKor(plantRegionEng: String) -> String {
        for i in 0..<regionList.region.count {
            for j in 0..<regionList.region[i].engCity.count {
                if plantRegionEng.contains(regionList.region[i].engCity[j]){
                    if regionList.region[i].city[j] != ""{
                        return "\(regionList.region[i].city[j]), \(regionList.region[i].name)"
                    }
                    else{
                        return "\(regionList.region[i].name)"
                    }
                }
            }
        }
        return ""
    }
    
    func setIcon(icon: String) -> String {
        return icon.contains("01") ? "sun" :
        icon.contains("02") ? "suncloud" :
        icon.contains("03") ? "cloud" :
        icon.contains("04") ? "cloud" :
        icon.contains("09") ? "rain" :
        icon.contains("10") ? "rain" :
        icon.contains("11") ? "thundercloud" :
        icon.contains("13") ? "snow" : "fog"
    }
    
    func setDday(date: String, waterCycle: Int) -> String{
        let latestWaterStr = date
        
        
        let latestWater = dateFormatter.date(from: latestWaterStr)
        
        let waterDate = Calendar.current.date(byAdding: .day, value: waterCycle, to: latestWater!)
        
        let offsetComps = Calendar.current.dateComponents([.day], from: Date(), to: waterDate!).day
        
        let today = dateFormatter.string(from: Date())
        let waterday = dateFormatter.string(from: waterDate!)
        
        if today == waterday{
            return "D-Day"
        }
        else if offsetComps! < 0 {
            return "D-Day"
        }
        else if offsetComps == 0 {
            return "D-1"
        }
        else{
            return "D-\(offsetComps! + 1)"
        }
    }
}
