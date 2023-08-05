//
//  SelectMyPlantViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/29.
//

import Foundation
import RxCocoa
import RxSwift

class SelectMyPlantViewModel {
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let selectPlant: Observable<Int>
    }
    
    struct Output {
        let dismissView = PublishRelay<Bool>()
    }
    
    let userId = UserDefaults.shared.integer(forKey: "id")
    
    var myPlantList = BehaviorRelay<[Myplant]>(value: [])
    private let myPlantModel = MyplantModel.shared
    
    init(){}
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlantModel.readPlantList(userId: owner.userId)
            }).disposed(by: disposeBag)
        
        input.selectPlant
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlantModel.myPlant.onNext(owner.myPlantList.value[value])
                output.dismissView.accept(true)
            }).disposed(by: disposeBag)
        
        self.myPlantModel.myPlantList
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                var temp = value
                temp.insert(Myplant(id: -1, userId: owner.userId, nickname: "전체", species: "", sunCondition: 0.0, windCondition: 0.0, waterCondition: 0.0, waterCycle: 0, imgUrl: "saesak_basics", isActive: true, tempDate: "", icon: "", recommendStr: "", plantRegionEng: ""), at: 0)
                
                owner.myPlantList.accept(temp)
            }).disposed(by: disposeBag)

        return output
    }
}
