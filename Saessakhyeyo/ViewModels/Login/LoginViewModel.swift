//
//  UserViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/01.
//

import Foundation
import RxCocoa
import RxSwift

class LoginViewModel {
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let loginBtnTap: Observable<Void>
    }
    
    struct Output {
        let isBtnHidden = BehaviorRelay<Bool>(value: true)
        let presentMainView = PublishRelay<Bool>()
    }

    private let userModel = UserModel()
    
    init(){}

    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
            let output = Output()
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.userModel.kakaoLogin()
            }).disposed(by: disposeBag)
        
        input.loginBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.userModel.kakaoLogin()
            }).disposed(by: disposeBag)
        
        self.userModel.isBtnHidden
            .subscribe(onNext: { value in
                output.isBtnHidden.accept(value)
            }).disposed(by: disposeBag)
        
        self.userModel.presentMainView
            .subscribe(onNext: { value in
                output.presentMainView.accept(value)
            }).disposed(by: disposeBag)
            
            return output
        }
}
