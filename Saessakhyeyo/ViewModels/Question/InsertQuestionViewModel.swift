//
//  InsertQuestionViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/02.
//

import Foundation
import RxCocoa
import RxSwift

class InsertQuestionViewModel {
    
    struct Input {
        let viewWillAppearEvent: Observable<ViewMode>
        let textViewEdit: Observable<String>
        let categoryBtnTap: Observable<String>
        let backBtnTap: Observable<Void>
        let insertBtnTap: Observable<Data?>
        let imgDeleteBtnTap: Observable<Void>
    }
    
    struct Output {
        let dismissView = PublishRelay<Bool>()
        let textViewText = BehaviorRelay<String>(value: "")
        let categoryTitle = BehaviorRelay<String>(value: "")
        let imgData = BehaviorRelay<Int>(value: -1)
        let deleteImgData = BehaviorRelay<Bool>(value: false)
    }
    
    let userId = UserDefaults.shared.integer(forKey: "id")
    var question = Question()
    var viewMode = ViewMode.update
    var questionList: [Question]?
    private var questionModel = QuestionModel.shared
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if value == .create {
                    owner.question = Question()
                    output.categoryTitle.accept(owner.question.category)
                    output.textViewText.accept(owner.question.content)
                    if owner.question.isImg {
                        output.imgData.accept(owner.question.id)
                    }
                }
                owner.viewMode = value
            }).disposed(by: disposeBag)
        
        input.textViewEdit
            .withUnretained(self)
            .filter({ owner, value -> Bool in
                value != ""
            })
            .subscribe(onNext: { owner, value in
                owner.question.content = value
                output.textViewText.accept(value)
            }).disposed(by: disposeBag)
        
        input.categoryBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.question.category = value
            }).disposed(by: disposeBag)
        
        input.backBtnTap
            .subscribe(onNext: {
                output.dismissView.accept(true)
            }).disposed(by: disposeBag)
        
        input.insertBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if let value = value {
                    owner.question.isImg = true
                    owner.question.imgData = value
                } else {
                    owner.question.isImg = false
                }
                if owner.viewMode == .create {
                    owner.questionModel.insertQuestion(userId: owner.userId, question: owner.question)
                }
                else {
                    owner.questionModel.updateQuestion(question: owner.question)
                }
                output.dismissView.accept(true)
            }).disposed(by: disposeBag)
        
        input.imgDeleteBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.question.imgData = nil
                owner.question.isImg = false
                output.deleteImgData.accept(true)
            }).disposed(by: disposeBag)
        
        self.questionModel.question
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.question = value
                output.categoryTitle.accept(owner.question.category)
                output.textViewText.accept(owner.question.content)
                if owner.question.isImg {
                    output.imgData.accept(owner.question.id)
                }
            }).disposed(by: disposeBag)
        
        return output
    }
}
