//
//  DiaryListViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/25.
//

import Foundation
import RxCocoa
import RxSwift

class DiaryListViewModel {
    
    struct Input {
        let diaryCellTap: Observable<Int>
        let deleteDiary: Observable<Int>
        let backBtnTap: Observable<Void>
        let deleteBtnTap: Observable<Void>
    }
    
    struct Output {
        let didLoadPlantData = BehaviorRelay<[String]>(value: [])
        let dismissView = PublishRelay<Bool>()
        let presentDiaryView = PublishRelay<Bool>()
        let showDeleteView = PublishRelay<Bool>()
    }
    
    let userId = UserDefaults.shared.integer(forKey: "id")

    var diary: Diary?
    var diaryList = BehaviorRelay<[Diary]>(value: [])
    var myPlant: Myplant?
    private let myPlantModel = MyplantModel.shared
    private let diaryModel = DiaryModel.shared
    init(){}
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.deleteBtnTap
            .subscribe(onNext: {
                output.showDeleteView.accept(true)
            }).disposed(by: disposeBag)
        
        input.diaryCellTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.diaryModel.diary.onNext(owner.diaryList.value[value])
                output.presentDiaryView.accept(true)
            }).disposed(by: disposeBag)
        
        input.deleteDiary
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.diaryModel.deleteDiary(diaryId: owner.diaryList.value[value].id)
            }).disposed(by: disposeBag)
        
        input.backBtnTap
            .subscribe(onNext: {
                output.dismissView.accept(true)
            }).disposed(by: disposeBag)
        
        self.myPlantModel.myPlant
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlant = value
                owner.diaryModel.readDiaryList(plantId: value.id)
                output.didLoadPlantData.accept([value.nickname, value.imgUrl])
            }).disposed(by: disposeBag)
        
        self.diaryModel.diaryList
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
                if let index = owner.diaryList.value.firstIndex(where: { element in
                    element.id == value
                }) {
                    var temp = owner.diaryList.value
                    temp.remove(at: index)
                    owner.diaryList.accept(temp)
                }
            }).disposed(by: disposeBag)
        
        return output
    }
}

