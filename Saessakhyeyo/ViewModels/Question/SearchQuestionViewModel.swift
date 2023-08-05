//
//  SearchQuestionViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/02.
//

import Foundation
import RxCocoa
import RxSwift

class SearchQuestionViewModel {
    struct Input {
        let searchBtnTap: Observable<String>
        let textFieldEdit: Observable<String>
        let clearBtnTap: Observable<Void>
        let segmentTap: Observable<Int>
        let selectQuestion: Observable<Int>
    }
    
    struct Output {
        let hideKeyboard = BehaviorRelay<Bool>(value: false)
        let textFieldText = BehaviorRelay<String>(value: "")
        let hideClearBtn = BehaviorRelay<Bool>(value: false)
        let presentReadQuestionView = PublishRelay<Bool>()
    }

    var question: Question?
    var questionList = BehaviorRelay<[Question]>(value: [])

    private let questionModel = QuestionModel.shared
    
    init(){}
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.searchBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.questionModel.searchQuestions(content: value, category: owner.question?.category ?? "전체")
                output.hideKeyboard.accept(true)
            }).disposed(by: disposeBag)
        
        input.segmentTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.question?.category = (value == 0 ? "전체" : value == 1 ? "식물관리" : value == 2 ? "아파요" : value == 3 ? "식물종찾기" : "꿀팁공유")
            }).disposed(by: disposeBag)
        
        input.textFieldEdit
            .subscribe(onNext: { value in
                if value != "" {
                    output.hideClearBtn.accept(false)
                } else {
                    output.hideClearBtn.accept(true)
                }
            }).disposed(by: disposeBag)
        
        input.clearBtnTap
            .subscribe(onNext: {
                output.textFieldText.accept("")
            }).disposed(by: disposeBag)
        
        input.selectQuestion
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.questionModel.readDetailQuestion(questionId: owner.questionList.value[value].id)
                output.presentReadQuestionView.accept(true)
            }).disposed(by: disposeBag)
        
        self.questionModel.filterdQuestionList
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.questionList.accept(value)
            }).disposed(by: disposeBag)
        
        return output
    }
}
