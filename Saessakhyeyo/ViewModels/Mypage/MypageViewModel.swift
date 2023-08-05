//
//  MypageViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/29.
//

import Foundation
import RxCocoa
import RxSwift

class MypageViewModel {
    
    struct Input {
        let settingBtnTap: Observable<Void>
        let diaryCellTap: Observable<Int>
    }
    
    struct Output {
        let userNameText = PublishRelay<String>()
        let myPlantCount = PublishRelay<Int>()
        let diaryCount = PublishRelay<Int>()
        let presentSettingSideMenu = PublishRelay<Bool>()
        let presentDiaryView = PublishRelay<Int>()
    }
    
    let userId = UserDefaults.shared.integer(forKey: "id")
    let userName =  UserDefaults.shared.string(forKey: "nickname")
    
    var diaryList = BehaviorRelay<[Diary]>(value: [])
    var myPlant: Myplant?
    private let myPlantModel = MyplantModel.shared
    private let diaryModel = DiaryModel.shared
    private let userModel = UserModel()
    init(){}
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.settingBtnTap
            .subscribe(onNext: {
                output.presentSettingSideMenu.accept(true)
            }).disposed(by: disposeBag)
        
        input.diaryCellTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlantModel.readPlantOne(userId: owner.userId, plantId: owner.diaryList.value[value].myPlantId)
                owner.diaryModel.diary.onNext(owner.diaryList.value[value])
                output.presentDiaryView.accept(value)
            }).disposed(by: disposeBag)
        
        self.myPlantModel.myPlant
            .withUnretained(self)
            .filter({ owner, value -> Bool in
                value.id != -1
            })
            .subscribe(onNext: { owner, value in
                owner.myPlant = value
            }).disposed(by: disposeBag)
        
        self.userModel.myPlantCnt
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                output.myPlantCount.accept(value)
                output.userNameText.accept(owner.userName!)
            }).disposed(by: disposeBag)
        
        self.diaryModel.allPlantdiaryList
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.diaryList.accept(value)
                output.diaryCount.accept(owner.diaryList.value.count)
            }).disposed(by: disposeBag)
        
        self.diaryModel.updateDiary
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                for i in 0..<owner.diaryList.value.count {
                    if owner.diaryList.value[i].id == value.id {
                        var temp = owner.diaryList.value
                        temp[i] = value
                        owner.diaryList.accept(temp)
                        break
                    }
                }
            }).disposed(by: disposeBag)
        
        self.diaryModel.isDelete
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if let index = owner.diaryList.value.firstIndex(where: { element in
                    element.id == value
                }) {
                    var temp = owner.diaryList.value
                    temp.remove(at: index)
                    owner.diaryList.accept(temp)
                }
            }).disposed(by: disposeBag)
        
        TabbarViewController.tabBarTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if value == 4 {
                    owner.userModel.getMyPlantCount(userId: owner.userId)
                    owner.diaryModel.readDiaryAll(userId: owner.userId)
                }
            }).disposed(by: disposeBag)
        
        return output
    }
}
