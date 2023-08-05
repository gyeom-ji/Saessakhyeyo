//
//  PlanModel.swift
//  FirstProject
//
//  Created by 윤겸지 on 2022/11/09.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift
import WidgetKit

struct PlanModel {
    static let shared = PlanModel()
    
    var updatePlan = BehaviorSubject<Plan>(value: Plan())
    var plan = BehaviorSubject<Plan>(value: Plan())
    var planList = BehaviorSubject<[Plan]>(value: [])
    var monthlyPlanList = BehaviorSubject<[Plan]>(value: [])
    var isDelete = PublishSubject<Int>()
    var isWatering = BehaviorSubject<Int>(value: 0)
    
    private init(){}
    private let disposeBag = DisposeBag()
    
    var dateFormat: DateFormatter {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd"
        return dateFormat
    }
    
    func readPlan(userId: Int)
    {
        let dateString = dateFormat.string(from: Date())
        
        let url = APIConstrants.baseURL + "/plan/\(dateString)/user=\(userId)"
        
        let headers: Alamofire.HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<[Plan]>(url: URL(string: url)!, method: .get, headers: headers)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                self.planList.onNext(result)
                print(result)
            }).disposed(by: disposeBag)
    }
    
    func readPlan(userId: Int, year: Int, month: Int, myPlantId: Int)
    {
        var url = String()
        if myPlantId == -1 {
            url = APIConstrants.baseURL + "/plan/\(year)/\(month)/user=\(userId)"
        } else {
            url = APIConstrants.baseURL + "/plan/\(year)/\(month)/my-plant=\(myPlantId)"
        }
        
        let headers: Alamofire.HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<[Plan]>(url: URL(string: url)!, method: .get, headers: headers)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                self.monthlyPlanList.onNext(result)
                print(result)
            }).disposed(by: disposeBag)
    }
    
    func updateWaterPlant(plantId:Int, type: String){
        
        let url = APIConstrants.baseURL + "/plan/\(plantId)/water/\(type)"
        
        let headers: Alamofire.HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<Int>(url: URL(string: url)!, method: .put, headers: headers)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                self.isWatering.onNext(result)
                WidgetCenter.shared.reloadAllTimelines()
                print(result)
            }).disposed(by: disposeBag)
    }
    
    func deletePlan(planId:Int)
    {
        let url = APIConstrants.baseURL+"/plan/\(planId)"
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<Bool>(url: URL(string: url)!, method: .delete, headers: header)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                self.isDelete.onNext(planId)
                WidgetCenter.shared.reloadTimelines(ofKind: "SaessakWidget")
            }).disposed(by: disposeBag)
    }
    
    func updatePlan(plan: Plan)
    {
        let url = APIConstrants.baseURL+"/plan/\(plan.id)"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let body : Parameters = [
            "date" : plan.date,
            "planType" : plan.planType,
            "myplant_id": plan.myplantId,
            "done": plan.isDone
        ]
        print(body)
        let resource = Resource<Int>(url: URL(string: url)!, method: .put, headers: header, body: body)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                self.updatePlan.onNext(plan)
                if plan.planType == "water" {
                    WidgetCenter.shared.reloadAllTimelines()
                } else {
                    WidgetCenter.shared.reloadTimelines(ofKind: "SaessakWidget")
                }
            }).disposed(by: disposeBag)
    }
    
    func insertPlan(userId: Int, plan: Plan)
    {
        let url = APIConstrants.baseURL+"/plan/"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let body : Parameters = [
            "userId": userId,
            "id": 0,
            "date" : plan.date,
            "planType" : plan.planType,
            "myplant_id": plan.myplantId,
            "done": plan.isDone
        ]
        
        let resource = Resource<Int>(url: URL(string: url)!, method: .post, headers: header, body: body)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                var temp = plan
                temp.id = result
                self.plan.onNext(temp)
                if temp.planType == "water" {
                    WidgetCenter.shared.reloadAllTimelines()
                } else {
                    WidgetCenter.shared.reloadTimelines(ofKind: "SaessakWidget")
                }
            }).disposed(by: disposeBag)
    }
}
