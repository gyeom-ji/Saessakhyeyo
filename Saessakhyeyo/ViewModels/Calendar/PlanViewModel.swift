//
//  PlanViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/30.
//

import Foundation
import RxCocoa
import RxSwift

class PlanViewModel {
    
    struct Input {
        let saveBtnTap: Observable<Bool>
        let selectPlanDate: Observable<Date>
        let selectPlanType: Observable<String>
        let isActiveSwitch: Observable<Bool>
    }
    
    struct Output {
        let planDate = BehaviorRelay<Date>(value: Date())
        let isActive = BehaviorRelay<Bool>(value: true)
        let planType = BehaviorRelay<String>(value: "")
    }
    
    let userId = UserDefaults.shared.integer(forKey: "id")
    var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter
    }()

    var plan = Plan()
    var viewMode = ViewMode.create
    private let planModel = PlanModel.shared
    init(){}
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.saveBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if owner.viewMode == .create {
                    owner.planModel.insertPlan(userId: owner.userId, plan: owner.plan)
                } else {
                    owner.planModel.updatePlan(plan: owner.plan)
                }
            }).disposed(by: disposeBag)
        
        input.selectPlanDate
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.plan.date = owner.dateFormatter.string(from: value)
            }).disposed(by: disposeBag)
        
        input.isActiveSwitch
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.plan.isDone = value
            }).disposed(by: disposeBag)
        
        input.selectPlanType
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.plan.planType = value
            }).disposed(by: disposeBag)
        
        self.planModel.plan
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.plan = value
                output.planDate.accept(owner.dateFormatter.date(from: owner.plan.date)!)
                output.isActive.accept(owner.plan.isDone)
                output.planType.accept(owner.plan.planType)
            }).disposed(by: disposeBag)
        
        return output
    }
}
