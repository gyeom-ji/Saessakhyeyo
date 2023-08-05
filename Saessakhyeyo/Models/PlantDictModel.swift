//
//  PlantDictModel.swift
//  FirstProject
//
//  Created by 윤겸지 on 2022/10/18.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

struct PlantDictModel {
    static let shared = PlantDictModel()
    
    var dict = BehaviorSubject<Dict>(value: Dict())
    var dictList = BehaviorRelay<[Dict]>(value: [])
    var sectionList = BehaviorRelay<[SectionDict]>(value: [])
    var selectPlantDict =  BehaviorSubject<Array<Dictionary<String, String>>>(value: [])
    
    private init(){}
    private let disposeBag = DisposeBag()
    
    func readAllDicts(){
        
        var tempList = [Dict]()
        var sectionDict : [SectionDict] = []
        
        let url = APIConstrants.baseURL+"/plant-dict"

        let header : HTTPHeaders = ["Content-Type" : "application/json" ]

        let resource = Resource<[Dict]>(url: URL(string: url)!, method: .get, headers: header)

        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                tempList = result
                tempList.sort(by: {$0.plantName < $1.plantName })
                
                for i in 0..<Hangul().CHO.count{
                    var list: [Dict] = []
                    for j in 0..<result.count {
                        if tempList[j].plantName.consonant == Hangul().CHO[i]{
                            list.append(tempList[j])
                        }
                    }
                    sectionDict.append(SectionDict(title: Hangul().CHO[i], dict: list))
                }
                sectionList.accept(sectionDict)
                dictList.accept(tempList)
                
            }).disposed(by: disposeBag)
    }
    
    func readDict1(plantId: Int){
        var plantDict :  Array<Dictionary<String, String>> = []
        
        let url = APIConstrants.baseURL+"/plant-dict/1/\(plantId)"

        let header : HTTPHeaders = ["Content-Type" : "application/json" ]

        let resource = Resource<PlantDict1>(url: URL(string: url)!, method: .get, headers: header)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                
                var temp : Dictionary<String, String> = ["title":"성장 높이", "text":String(result.growthHg)]
                plantDict.append(temp)
                temp = ["title":"성장 넓이", "text": String(result.growthAra)]
                plantDict.append(temp)
                temp = ["title":"관리 수준", "text": result.manageLevel]
                plantDict.append(temp)
                temp = ["title":"월동 온도", "text": result.winterMinTemp]
                plantDict.append(temp)
                temp = ["title":"습도", "text": result.humidity]
                plantDict.append(temp)
                temp = ["title":"비료 정보", "text": result.fertilizer]
                plantDict.append(temp)
                temp = ["title":"토양 정보", "text": result.soilInfo]
                plantDict.append(temp)
                temp = ["title":"봄 물주기", "text": result.waterCycleSpring]
                plantDict.append(temp)
                temp = ["title":"여름 물주기", "text": result.waterCycleSummer]
                plantDict.append(temp)
                temp = ["title":"가을 물주기", "text": result.waterCycleAutumn]
                plantDict.append(temp)
                temp = ["title":"겨울 물주기", "text": result.waterCycleWinter]
                plantDict.append(temp)
                temp = ["title":"특별 관리 정보", "text": result.speclManageInfo]
                plantDict.append(temp)
                temp = ["title":"번식 방법", "text": result.prpgtMth]
                plantDict.append(temp)
                temp = ["title":"광요구도", "text": result.lightDemand]
                plantDict.append(temp)
                temp = ["title":"병충해", "text": result.pest]
                plantDict.append(temp)
                print(result)
                selectPlantDict.onNext(plantDict)
            }).disposed(by: disposeBag)
    }
    
    func readDict2(plantId: Int){
    
        var plantDict :  Array<Dictionary<String, String>> = []
        
        let url = APIConstrants.baseURL+"/plant-dict/2/\(plantId)"

        let header : HTTPHeaders = ["Content-Type" : "application/json" ]

        let resource = Resource<PlantDict2>(url: URL(string: url)!, method: .get, headers: header)

        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in

                var temp : Dictionary<String, String> = ["title":"생장형", "text": result.growthInfo]
                plantDict.append(temp)
                temp = ["title":"생장 속도", "text": result.growthSpeed]
                plantDict.append(temp)
                temp = ["title":"관리 수준", "text": result.manageLevel]
                plantDict.append(temp)
                temp = ["title":"월동 온도", "text": result.winterMinTemp]
                plantDict.append(temp)
                temp = ["title":"특징", "text": result.character]
                plantDict.append(temp)
                temp = ["title":"물주기", "text": result.waterCycle]
                plantDict.append(temp)
                temp = ["title":"배치 장소", "text": result.batchPlace]
                plantDict.append(temp)
                temp = ["title":"팁", "text": result.tip]
                plantDict.append(temp)
                temp = ["title":"번식 방법", "text": result.prpgtMth]
                plantDict.append(temp)
                temp = ["title":"광요구도", "text": result.lightDemand]
                plantDict.append(temp)
                temp = ["title":"병충해", "text": result.pest]
                plantDict.append(temp)
                print(result)
                selectPlantDict.onNext(plantDict)
            }).disposed(by: disposeBag)
    }
    
    func readDict3(plantId: Int){
        var plantDict :  Array<Dictionary<String, String>> = []
        
        let url = APIConstrants.baseURL+"/plant-dict/3/\(plantId)"

        let header : HTTPHeaders = ["Content-Type" : "application/json" ]

        let resource = Resource<PlantDict3>(url: URL(string: url)!, method: .get, headers: header)

        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                
                var temp : Dictionary<String, String> = ["title":"파종 시기", "text": result.sowingSeason]
                plantDict.append(temp)
                temp = ["title":"수확 시기", "text": result.hvtSeason]
                plantDict.append(temp)
                temp = ["title":"특징", "text": result.character]
                plantDict.append(temp)
                temp = ["title":"재배 정보", "text": result.cultInfo]
                plantDict.append(temp)
                print(result)
                selectPlantDict.onNext(plantDict)
            }).disposed(by: disposeBag)
    }
}

