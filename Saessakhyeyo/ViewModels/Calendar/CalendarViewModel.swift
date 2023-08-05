//
//  CalendarViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/29.
//

import Foundation
import RxCocoa
import RxSwift

class CalendarViewModel {
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let showPlantListBtnTap: Observable<Void>
        let insertPlanBtnTap: Observable<Void>
        let backBtnTap: Observable<Void>
        let updatePlanBtnTap: Observable<Int>
        let deletePlanBtnTap: Observable<Int>
        let calendarPageDidChange: Observable<[Int]> //0 year, 1 month
        let didSelectDate: Observable<Date>
    }
    
    struct Output {
        let didLoadPlantData = BehaviorRelay<[String]>(value: [])
        let presentMyPlantSelectView = PublishRelay<Bool>()
        let presentPlanView = PublishRelay<ViewMode>()
        let hideInsertBtn = PublishRelay<Bool>()
        let dismissView = PublishRelay<Bool>()
    }
    
    let userId = UserDefaults.shared.integer(forKey: "id")
    var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter
    }()

    var planList = BehaviorRelay<[Plan]>(value: [])
    var filterdPlanList = BehaviorRelay<[Plan]>(value: [])
    var currentCalDate = [Calendar.current.component(.year, from: Date()), Calendar.current.component(.month, from: Date())]
    var selectDate = Date()
    var myPlant = Myplant()
    private let myPlantModel = MyplantModel.shared
    private let planModel = PlanModel.shared
    
    init(){}
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.setFilterdPlanList(value: owner.selectDate)
            }).disposed(by: disposeBag)
        
        input.showPlantListBtnTap
            .subscribe(onNext: {
                output.presentMyPlantSelectView.accept(true)
            }).disposed(by: disposeBag)
        
        input.insertPlanBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.planModel.plan.onNext(Plan(id: -1, date: owner.dateFormatter.string(from: owner.selectDate), planType: "water", myplantId: owner.myPlant.id, myplantName: owner.myPlant.nickname, isDone: false))
                output.presentPlanView.accept(.create)
            }).disposed(by: disposeBag)
        
        input.updatePlanBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                print("====updatePlanBtnTap====")
                print(value)
                if let updatePlan = owner.filterdPlanList.value.first(where: { element -> Bool in
                    element.id == value
                }) {
                    owner.planModel.plan.onNext(updatePlan)
                    output.presentPlanView.accept(.update)
                }
            }).disposed(by: disposeBag)
        
        input.deletePlanBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                print("====deletePlanBtnTap====")
                print(value)
               owner.planModel.deletePlan(planId: value)
            }).disposed(by: disposeBag)
        
        input.backBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                if owner.myPlant.nickname == "전체" {
                    owner.myPlantModel.myPlant.onNext(owner.myPlantModel.myPlantList.value[0])
                }
                output.dismissView.accept(false)
            }).disposed(by: disposeBag)
        
        input.calendarPageDidChange
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.currentCalDate = value
                owner.planModel.readPlan(userId: owner.userId, year: value[0], month: value[1], myPlantId: owner.myPlant.id)
            }).disposed(by: disposeBag)
        
        input.didSelectDate
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.selectDate = value
                owner.setFilterdPlanList(value: value)
            }).disposed(by: disposeBag)
        
        self.myPlantModel.myPlant
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlant = value
                owner.planModel.readPlan(userId: owner.userId, year: owner.currentCalDate[0], month: owner.currentCalDate[1], myPlantId: owner.myPlant.id)
                
                output.hideInsertBtn.accept(owner.myPlant.nickname == "전체" ? true : false)
                output.didLoadPlantData.accept([value.nickname, value.imgUrl, value.dday ?? ""])
            }).disposed(by: disposeBag)
        
        self.planModel.monthlyPlanList
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.planList.accept(value)
                owner.setFilterdPlanList(value: owner.selectDate)
            }).disposed(by: disposeBag)
        
        self.planModel.plan
            .withUnretained(self)
            .filter({ owner, value -> Bool in
                value.id != -1
            })
            .filter({ owner, value -> Bool in
               !owner.planList.value.contains(where: { element -> Bool in
                   element.id == value.id
                })
            })
            .subscribe(onNext: { owner, value in
                var temp = owner.planList.value
                temp.insert(value, at: 0)
                owner.planList.accept(temp)
            }).disposed(by: disposeBag)
        
        self.planModel.plan
            .withUnretained(self)
            .filter({ owner, value -> Bool in
                value.id != -1 && value.date == owner.dateFormatter.string(from: owner.selectDate)
            })
            .filter({ owner, value -> Bool in
               !owner.filterdPlanList.value.contains(where: { element -> Bool in
                   element.id == value.id
                })
            })
            .subscribe(onNext: { owner, value in
                var temp = owner.filterdPlanList.value
                temp.insert(value, at: 0)
                owner.filterdPlanList.accept(temp)
            }).disposed(by: disposeBag)
        
        self.planModel.updatePlan
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if let index = owner.planList.value.firstIndex(where: { element in
                    element.id == value.id
                }) {
                    var temp = owner.planList.value
                    temp[index] = value
                    owner.planList.accept(temp)
                }
                
                if let filterIndex = owner.filterdPlanList.value.firstIndex(where: { element in
                    element.id == value.id
                }) {
                    var temp = owner.filterdPlanList.value
                    temp[filterIndex] = value
                    owner.filterdPlanList.accept(temp)
                }
            }).disposed(by: disposeBag)
        
        self.planModel.isDelete
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if let index = owner.planList.value.firstIndex(where: { element in
                    element.id == value
                }) {
                    var temp = owner.planList.value
                    temp.remove(at: index)
                    owner.planList.accept(temp)
                }
                
                if let filterIndex = owner.filterdPlanList.value.firstIndex(where: { element in
                    element.id == value
                }) {
                    var temp = owner.filterdPlanList.value
                    temp.remove(at: filterIndex)
                    owner.filterdPlanList.accept(temp)
                }
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func setFilterdPlanList(value: Date) {
        var temp : [Plan] = []
        for i in 0..<planList.value.count {
            if planList.value[i].date == dateFormatter.string(from: value) {
                temp.append(planList.value[i])
            }
        }
        filterdPlanList.accept(temp)
    }
}
