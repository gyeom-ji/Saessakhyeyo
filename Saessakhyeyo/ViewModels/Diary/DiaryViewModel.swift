//
//  DiaryViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/25.
//

import Foundation
import RxCocoa
import RxSwift

class DiaryViewModel {
    
    struct Input {
        let viewWillAppearEvent: Observable<ViewMode>
        let viewWillDisappearEvent: Observable<Data?>
        let backBtnTap: Observable<Void>
        let weatherBtnTap: Observable<Void>
        let conditionBtnTap: Observable<Void>
        let activityBtnTap: Observable<Void>
        let activityBtn2Tap: Observable<Void>
        let activityBtn3Tap: Observable<Void>
        let deleteBtnTap: Observable<Void>
        let imgDeleteBtnTap: Observable<Void>
        let selectWeather: Observable<String>
        let selectCond: Observable<String>
        let selectActivity: Observable<[String]>
        let textViewEdit: Observable<String>
    }
    
    struct Output {
        let didLoadPlantData = BehaviorRelay<[String]>(value: [])
        let isHiddenShowPlantListBtn = BehaviorRelay<Bool>(value: true)
        let dateText = BehaviorRelay<String>(value: "")
        let timeText = BehaviorRelay<String>(value: "")
        let diaryImgData = BehaviorRelay<Int>(value: -1)
        let weatherImg = BehaviorRelay<String>(value: "")
        let conditionImg = BehaviorRelay<String>(value: "")
        let activityImg = BehaviorRelay<[String]>(value: [])
        let textViewText = BehaviorRelay<String>(value: "")
        let dismissView = PublishRelay<Bool>()
        let presentDiaryIconSelectView = PublishRelay<String>()
        let deleteImgData = BehaviorRelay<Bool>(value: false)
    }
    
    let userId = UserDefaults.shared.integer(forKey: "id")
    var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 d일 EEEE"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        return dateFormatter
    }()
    var timeFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "a h:mm"
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        return dateFormatter
    }()
   
    var myPlantId = Int()
    var diary = Diary()
    private let myPlantModel = MyplantModel.shared
    private let diaryModel = DiaryModel.shared
    private var viewMode = ViewMode.create
    init(){}
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()

        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.viewMode = value
                output.isHiddenShowPlantListBtn.accept(owner.viewMode == .update ? true : false)
                if value == .create {
                    owner.diary.date = owner.dateFormatter.string(from: Date())
                    owner.diary.time = owner.timeFormatter.string(from: Date())
                    output.timeText.accept(owner.diary.time)
                    output.dateText.accept(owner.diary.date)
                }
            }).disposed(by: disposeBag)
        
        input.viewWillDisappearEvent
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if let value = value {
                    owner.diary.isImg = true
                    owner.diary.imgData = value
                } else {
                    owner.diary.isImg = false
                }
                
                if owner.viewMode == .update {
                    owner.diaryModel.updateDiary(diary: owner.diary)
                } else {
                    owner.diary.myPlantId = owner.myPlantId
                    owner.diaryModel.insertDiary(userId: owner.userId, diary: owner.diary)
                }
            }).disposed(by: disposeBag)
        
        input.backBtnTap
            .subscribe(onNext: { value in
                output.dismissView.accept(true)
            }).disposed(by: disposeBag)

        input.weatherBtnTap
            .subscribe(onNext: {
                output.presentDiaryIconSelectView.accept("weather")
            }).disposed(by: disposeBag)
        
        input.conditionBtnTap
            .subscribe(onNext: {
                output.presentDiaryIconSelectView.accept("condition")
            }).disposed(by: disposeBag)
        
        input.activityBtnTap
            .subscribe(onNext: {
                output.presentDiaryIconSelectView.accept("activity")
            }).disposed(by: disposeBag)
        
        input.activityBtn2Tap
            .subscribe(onNext: {
                output.presentDiaryIconSelectView.accept("activity")
            }).disposed(by: disposeBag)
        
        input.activityBtn3Tap
            .subscribe(onNext: {
                output.presentDiaryIconSelectView.accept("activity")
            }).disposed(by: disposeBag)
        
        input.deleteBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                self.diaryModel.deleteDiary(diaryId: owner.diary.id)
            }).disposed(by: disposeBag)
        
        input.imgDeleteBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.diary.imgData = nil
                owner.diary.isImg = false
                output.deleteImgData.accept(true)
            }).disposed(by: disposeBag)
        
        input.selectWeather
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.diary.weather = value
                output.weatherImg.accept(value)
            }).disposed(by: disposeBag)
        
        input.selectCond
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.diary.cond = value
                output.conditionImg.accept(value)
            }).disposed(by: disposeBag)
        
        input.selectActivity
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if value.count > 0 {
                    owner.diary.activity1 = value[0]
                } else {
                    owner.diary.activity1 = ""
                }
                if value.count > 1 {
                    owner.diary.activity2 = value[1]
                } else {
                    owner.diary.activity2 = ""
                }
                if value.count > 2 {
                    owner.diary.activity3 = value[2]
                } else {
                    owner.diary.activity3 = ""
                }
                output.activityImg.accept(value)
            }).disposed(by: disposeBag)
        
        input.textViewEdit
            .withUnretained(self)
            .filter({ owner, value -> Bool in
                value != ""
            })
            .subscribe(onNext: { owner, value in
                owner.diary.content = value
                output.textViewText.accept(value)
            }).disposed(by: disposeBag)
        
        self.myPlantModel.myPlant
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlantId = value.id
                output.didLoadPlantData.accept([value.nickname, value.imgUrl])
            }).disposed(by: disposeBag)
        
        self.diaryModel.diary
            .withUnretained(self)
            .filter({ owner, value -> Bool in
                value.id != -1
            })
            .subscribe(onNext: { owner, value in
                owner.diary = value
                output.timeText.accept(value.time)
                output.dateText.accept(value.date)
                output.weatherImg.accept(value.weather)
                output.conditionImg.accept(value.cond)
                output.activityImg.accept([value.activity1, value.activity2, value.activity3])
                output.textViewText.accept(value.content)
                if value.isImg {
                    output.diaryImgData.accept(value.id)
                }
            }).disposed(by: disposeBag)
        
        self.diaryModel.isDelete
            .subscribe(onNext: { value in
                output.dismissView.accept(true)
            }).disposed(by: disposeBag)

        return output
    }
}

