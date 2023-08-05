//
//  ReadDictViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/04.
//

import Foundation
import RxCocoa
import RxSwift

final class ReadDictViewModel {
    
    struct Input {
        let backBtnTap: Observable<Void>
    }
    
    struct Output {
        let plantName = BehaviorRelay<String>(value: "")
        let plantImg = BehaviorRelay<String>(value: "")
        let dismissView = PublishRelay<Bool>()
    }

    private var dictModel = PlantDictModel.shared
    var selectPlantDict = BehaviorRelay<Array<Dictionary<String, String>>>(value: [])
    
    init(){}
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.backBtnTap
            .subscribe(onNext: {
               output.dismissView.accept(true)
            }).disposed(by: disposeBag)
        
        self.dictModel.dict
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                output.plantImg.accept(value.imgUrl)
                output.plantName.accept(value.plantName)
                
                if value.dType == "DICT1"{
                    owner.dictModel.readDict1(plantId: value.idFromEachDict)
                }
                if value.dType == "DICT2" {
                    owner.dictModel.readDict2(plantId: value.idFromEachDict)
                }
                if value.dType == "DICT3" {
                    owner.dictModel.readDict3(plantId: value.idFromEachDict)
                }
            }).disposed(by: disposeBag)
        
        self.dictModel.selectPlantDict
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.selectPlantDict.accept(value)
            }).disposed(by: disposeBag)
        
        return output
    }
}
