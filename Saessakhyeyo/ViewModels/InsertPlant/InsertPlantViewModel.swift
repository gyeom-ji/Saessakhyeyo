//
//  InsertPlantViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/05.
//

import Foundation
import RxCocoa
import RxSwift

final class InsertPlantViewModel {
    
    struct Input {
        let viewWillAppearEvent: Observable<ViewMode>
        let backBtnTap: Observable<Void>
        let searchBtnTap: Observable<Void>
        let saveBtnTap: Observable<Void>
        let regionBtnTap: Observable<Void>
        let selectRegion: Observable<[String]>
        let waterCycleBtnTap: Observable<Void>
        let selectWaterCycle: Observable<Int>
        let waterSliderDrag: Observable<Float>
        let windSliderDrag: Observable<Float>
        let sunSliderDrag: Observable<Float>
        let isActiveSwitch: Observable<Bool>
        let selectLatestDate: Observable<Date>
        let textFieldEdit: Observable<String>
    }
    
    struct Output {
        let plantSpecies = BehaviorRelay<String>(value: "")
        let plantImg = BehaviorRelay<String>(value: "")
        let waterRec = BehaviorRelay<String>(value: "")
        let region = BehaviorRelay<String>(value: "")
        let presentWaterCycleView = PublishRelay<Bool>()
        let presentSearchView = PublishRelay<Bool>()
        let presentRegionView = PublishRelay<Bool>()
        let sunSlider = BehaviorRelay<Float>(value: 0.0)
        let waterSlider = BehaviorRelay<Float>(value: 0.0)
        let windSlider = BehaviorRelay<Float>(value: 0.0)
        let waterCycle = BehaviorRelay<String>(value: "")
        let dismissView = PublishRelay<Bool>()
        let plantNickName = BehaviorRelay<String>(value: "")
        let latestWaterDate = BehaviorRelay<Date>(value: Date())
        let isActive = BehaviorRelay<Bool>(value: true)
    }
    
    let userId = UserDefaults.shared.integer(forKey: "id")
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter
    }
    
    var myPlant = Myplant()
    var selectRow = Int()
    var viewMode = ViewMode.create
    private var myPlantModel = MyplantModel.shared
    private var dictModel = PlantDictModel.shared

    init(){}
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if value == .create {
                    owner.dictModel.dict.onNext(Dict())
                    owner.myPlant = Myplant()
                    output.plantSpecies.accept("")
                    output.plantImg.accept("saesak_basics")
                    output.region.accept("")
                    output.sunSlider.accept(0.0)
                    output.windSlider.accept(0.0)
                    output.waterSlider.accept(0.0)
                    output.waterCycle.accept("1일")
                    output.plantNickName.accept("")
                    output.latestWaterDate.accept(Date())
                    output.isActive.accept(true)
                }
                owner.viewMode = value
            }).disposed(by: disposeBag)
        
        input.backBtnTap
            .subscribe(onNext: {
                output.dismissView.accept(true)
            }).disposed(by: disposeBag)
        
        input.textFieldEdit
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlant.nickname = value
            }).disposed(by: disposeBag)
        
        input.searchBtnTap
            .subscribe(onNext: {
               output.presentSearchView.accept(true)
            }).disposed(by: disposeBag)
        
        input.regionBtnTap
            .subscribe(onNext: {
                output.presentRegionView.accept(true)
            }).disposed(by: disposeBag)
        
        input.selectRegion
            .withUnretained(self)
            .filter({ owner, value -> Bool in
                value.count > 1
            })
            .subscribe(onNext: { owner, value in
                output.region.accept(value[0])
                owner.myPlant.plantRegionKor = value[0]
                owner.myPlant.plantRegionEng = value[1]
            }).disposed(by: disposeBag)
        
        input.isActiveSwitch
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlant.isActive = value
            }).disposed(by: disposeBag)
        
        input.selectLatestDate
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlant.tempDate = owner.dateFormatter.string(from: value)
            }).disposed(by: disposeBag)
        
        input.saveBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if owner.viewMode == .create {
                    output.plantSpecies.accept("")
                    output.plantImg.accept("saesak_basics")
                    output.region.accept("")
                    output.sunSlider.accept(0.0)
                    output.windSlider.accept(0.0)
                    output.waterSlider.accept(0.0)
                    output.waterCycle.accept("1일")
                    output.plantNickName.accept("")
                    output.latestWaterDate.accept(Date())
                    output.isActive.accept(true)
                    
                    owner.myPlantModel.insertMyPlant(userId: owner.userId, myPlant: owner.myPlant)
                } else {
                    owner.myPlantModel.updatePlantAll(plant: owner.myPlant)
                }
                owner.myPlant = Myplant()
            }).disposed(by: disposeBag)
        
        input.waterCycleBtnTap
            .subscribe(onNext: {
                output.presentWaterCycleView.accept(true)
            }).disposed(by: disposeBag)

        input.selectWaterCycle
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.selectRow = value
                owner.myPlant.waterCycle = value + 1
                output.waterCycle.accept("\(value + 1)일")
            }).disposed(by: disposeBag)
        
        input.waterSliderDrag
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlant.waterCondition = value
                output.waterSlider.accept(value)
            }).disposed(by: disposeBag)

        input.sunSliderDrag
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlant.sunCondition = value
                output.sunSlider.accept(value)
            }).disposed(by: disposeBag)
        
        input.windSliderDrag
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlant.windCondition = value
                output.windSlider.accept(value)
            }).disposed(by: disposeBag)
        
        input.windSliderDrag
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlant.windCondition = value
                output.windSlider.accept(value)
            }).disposed(by: disposeBag)
        
        self.myPlantModel.myPlant
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if owner.viewMode == .update {
                    owner.myPlant = value
                    output.plantSpecies.accept(value.species)
                    output.plantImg.accept(value.imgUrl)
                    output.region.accept(value.plantRegionKor!)
                    output.sunSlider.accept(value.sunCondition)
                    output.windSlider.accept(value.windCondition)
                    output.waterSlider.accept(value.waterCondition)
                    output.waterCycle.accept("\(value.waterCycle)일")
                    output.plantNickName.accept(value.nickname)
                    output.latestWaterDate.accept(owner.dateFormatter.date(from: value.tempDate)!)
                    output.isActive.accept(value.isActive)
                }
            }).disposed(by: disposeBag)
        
        self.dictModel.dict
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if owner.viewMode == .create {
                    owner.myPlant.species = value.plantName
                    owner.myPlant.imgUrl = value.imgUrl
                    owner.myPlant.waterCondition = value.waterValue
                    
                    output.plantSpecies.accept(value.plantName)
                    output.plantImg.accept(value.imgUrl == "" ? "saesak_basics" : value.imgUrl)
                    output.waterSlider.accept(value.waterValue)
                    output.waterRec.accept(value.waterRec)
                }
            }).disposed(by: disposeBag)
        
        return output
    }
}
