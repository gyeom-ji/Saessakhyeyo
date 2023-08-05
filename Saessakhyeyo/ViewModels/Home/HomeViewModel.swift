//
//  HomeViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/06.
//

import Foundation
import RxCocoa
import RxSwift

class HomeViewModel {
    
    struct Input {
        let plantInfoBtnTap: Observable<Void>
        let plantListBtnTap: Observable<Void>
        let calendarBtnTap: Observable<Void>
        let waterBtnTap: Observable<Void>
        let unWaterBtnTap: Observable<Void>
        let diaryCellTap: Observable<Int>
        let insertDiaryBtnTap: Observable<Void>
        let diaryListBtnTap: Observable<Void>
        let planCellTap: Observable<Int>
    }
    
    struct Output {
        let presentDiaryView = PublishRelay<Int>()
        let presentDiaryListView = PublishRelay<Bool>()
        let presentCalendarView = PublishRelay<Bool>()
        let presentPlantInfoView = PublishRelay<Bool>()
        let presentPlantListView = PublishRelay<Bool>()
        let waterChange = PublishRelay<Bool>()
        let waterdDayText = PublishRelay<String>()
        let dateText = PublishRelay<String>()
        let weatherInfo = PublishRelay<[String]>()
        let plantInfo = PublishRelay<[String]>()
    }
    
    let userId = UserDefaults.shared.integer(forKey: "id")
    var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter
    }()

    var planList = BehaviorRelay<[Plan]>(value: [])
    var diaryList = BehaviorRelay<[Diary]>(value: [])
    var myPlant: Myplant?
    private let myPlantModel = MyplantModel.shared
    private let diaryModel = DiaryModel.shared
    private let planModel = PlanModel.shared
    init(){}
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.plantInfoBtnTap
            .subscribe(onNext: {
                output.presentPlantInfoView.accept(true)
            }).disposed(by: disposeBag)
        
        input.plantListBtnTap
            .subscribe(onNext: {
                output.presentPlantListView.accept(true)
            }).disposed(by: disposeBag)
        
        input.calendarBtnTap
            .subscribe(onNext: {
                output.presentCalendarView.accept(true)
            }).disposed(by: disposeBag)
        
        input.waterBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                output.waterChange.accept(true)
                owner.planModel.updateWaterPlant(plantId: owner.myPlant!.id, type: "do")
            }).disposed(by: disposeBag)
        
        input.unWaterBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                output.waterChange.accept(false)
                owner.planModel.updateWaterPlant(plantId: owner.myPlant!.id, type: "undo")
            }).disposed(by: disposeBag)
        
        input.diaryCellTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlantModel.myPlant.onNext(owner.myPlant!)
                owner.diaryModel.diary.onNext(owner.diaryList.value[value])
                output.presentDiaryView.accept(value)
            }).disposed(by: disposeBag)
        
        input.insertDiaryBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.diaryModel.diary.onNext(Diary())
                output.presentDiaryView.accept(-1)
            }).disposed(by: disposeBag)
        
        input.diaryListBtnTap
            .subscribe(onNext: {
                output.presentDiaryListView.accept(true)
            }).disposed(by: disposeBag)
        
        input.planCellTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                var temp = owner.planList.value[value]
                temp.isDone = !temp.isDone
                owner.planModel.updatePlan(plan: temp)
            }).disposed(by: disposeBag)
        
        self.myPlantModel.myPlant
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.diaryModel.readRecentDiary(plantId: value.id)
                output.waterdDayText.accept(value.dday ?? "")
                output.weatherInfo.accept([value.icon, value.recommendStr])
                output.plantInfo.accept([value.nickname, value.imgUrl])
                output.dateText.accept("\(Calendar.current.component(.day, from: Date()))")
                owner.myPlant = value
            }).disposed(by: disposeBag)
        
        self.diaryModel.recentDiaryList
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.diaryList.accept(value)
            }).disposed(by: disposeBag)
        
        self.diaryModel.updateDiary
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if let index = owner.diaryList.value.firstIndex(where: { element in
                    element.id == value.id
                }) {
                    var temp = owner.diaryList.value
                    temp[index] = value
                    owner.diaryList.accept(temp)
                }
            }).disposed(by: disposeBag)
        
        self.diaryModel.isDelete
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if owner.diaryList.value.firstIndex(where: { element in
                    element.id == value
                }) != nil {
                    owner.diaryModel.readRecentDiary(plantId: owner.myPlant!.id)
                }
            }).disposed(by: disposeBag)
        
        self.diaryModel.diary
            .withUnretained(self)
            .filter({ owner, value -> Bool in
                value.id != -1
            })
            .filter({ owner, value -> Bool in
                !owner.diaryList.value.contains(where: { element -> Bool in
                   element.id == value.id
                })
            })
            .subscribe(onNext: { owner, value in
                var temp = owner.diaryList.value
                if temp.count > 2 {
                    temp.removeLast()
                } else {
                    temp.insert(value, at: 0)
                }
                owner.diaryList.accept(temp)
            }).disposed(by: disposeBag)
        
        self.planModel.planList
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.planList.accept(value)
            }).disposed(by: disposeBag)
        
        self.planModel.plan
            .withUnretained(self)
            .filter({ owner, value -> Bool in
                value.id != -1 && value.date == owner.dateFormatter.string(from: Date())
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
                
                owner.checkWaterPlan(planType: value.planType, myplantId: value.myplantId)
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
                owner.checkWaterPlan(planType: value.planType, myplantId: value.myplantId)
            }).disposed(by: disposeBag)
        
        self.planModel.isWatering
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlantModel.readPlantOne(userId: owner.userId, plantId: owner.myPlant!.id)
                owner.planModel.readPlan(userId: owner.userId)
            }).disposed(by: disposeBag)
        
        TabbarViewController.tabBarTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if value == 0 {
                    if owner.myPlant!.id == -1 {
                        owner.myPlantModel.readPlantOne(userId: owner.userId, plantId: 0)
                    } else {
                        owner.myPlantModel.readPlantOne(userId: owner.userId, plantId: owner.myPlant!.id)
                    }
                    owner.planModel.readPlan(userId: owner.userId)
                }
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func checkWaterPlan(planType: String, myplantId: Int){
        if planType == "water" && myplantId == self.myPlant!.id {
            self.myPlantModel.readPlantOne(userId: userId, plantId: myPlant!.id)
        }
    }
}
