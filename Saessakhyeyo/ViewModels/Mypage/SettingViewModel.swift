//
//  SettingViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/29.
//

import Foundation
import RxCocoa
import RxSwift

class SettingViewModel {
    
    struct Input {
        let isActiveAlarmSwitch: Observable<Bool>
        let isActiveLocationSwitch: Observable<Bool>
        let guideBtnTap: Observable<Void>
    }
    
    struct Output {
        let isActiveAlarm = PublishRelay<Bool>()
        let isActiveLocation = PublishRelay<Bool>()
        let presentGuideView = PublishRelay<Bool>()
    }

    init(){}
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.isActiveAlarmSwitch
            .subscribe(onNext: { value in
                output.isActiveAlarm.accept(value)
            }).disposed(by: disposeBag)
        
        input.isActiveLocationSwitch
            .subscribe(onNext: { value in
                output.isActiveLocation.accept(value)
            }).disposed(by: disposeBag)
        
        input.guideBtnTap
            .subscribe(onNext: {
                output.presentGuideView.accept(true)
            }).disposed(by: disposeBag)
        
        return output
    }
}
