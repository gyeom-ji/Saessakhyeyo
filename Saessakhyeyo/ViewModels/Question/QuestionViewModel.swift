//
//  QuestionViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/06/18.
//

import Foundation
import RxCocoa
import RxSwift

class QuestionViewModel {
    
    struct Input {
        let insertBtnTap: Observable<Void>
        let searchBtnTap: Observable<Void>
        let sortByDateBtnTap: Observable<Bool>
        let sortByCommentBtnTap: Observable<Bool>
        let selectQuestion: Observable<Int>
        let refreshTableView: Observable<Void>
    }
    
    struct Output {
        let presentInsertView = PublishRelay<Bool>()
        let presentSearchView = PublishRelay<Bool>()
        let presentReadQuestionView = PublishRelay<Bool>()
        let updateQuestionRow = PublishRelay<Int>()
        let deleteQuestionRow = PublishRelay<Int>()
        let endRefreshing = PublishRelay<Bool>()
    }
    
    var isUpdateImage = true
    var questionList =  BehaviorRelay<[Question]>(value: [])
    private let questionModel = QuestionModel.shared
    init(){}
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.insertBtnTap
            .subscribe(onNext: {
                output.presentInsertView.accept(true)
            }).disposed(by: disposeBag)
        
        input.searchBtnTap
            .subscribe(onNext: {
                output.presentSearchView.accept(true)
            }).disposed(by: disposeBag)
        
        input.sortByDateBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                var temp = owner.questionList.value
                temp.sort(by: {$0.dateTime > $1.dateTime})
                owner.questionList.accept(temp)
            }).disposed(by: disposeBag)
        
        input.sortByCommentBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                var temp = owner.questionList.value
                temp.sort(by: {$0.commentCnt > $1.commentCnt})
                owner.questionList.accept(temp)
            }).disposed(by: disposeBag)
        
        input.selectQuestion
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.questionModel.readDetailQuestion(questionId: owner.questionList.value[value].id)
                output.presentReadQuestionView.accept(true)
            }).disposed(by: disposeBag)
        
        input.refreshTableView
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.questionModel.readAllQuestions()
            }).disposed(by: disposeBag)
        
        self.questionModel.questionList
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.questionList.accept(value)
                output.endRefreshing.accept(true)
            }).disposed(by: disposeBag)
        
        self.questionModel.question
            .withUnretained(self)
            .filter({ owner, value -> Bool in
                value.id != -1
            })
            .filter({ owner, value -> Bool in
                !owner.questionList.value.contains(where: { element -> Bool in
                    element.id == value.id
                })
            })
            .subscribe(onNext: { owner, value in
                self.questionModel.readAllQuestions()
            }).disposed(by: disposeBag)
        
        self.questionModel.updateQuestion
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                for i in 0..<owner.questionList.value.count {
                    if owner.questionList.value[i].id == value.id {
                        var temp = owner.questionList.value
                        temp[i] = value
                        owner.questionList.accept(temp)
                        break
                    }
                }
            }).disposed(by: disposeBag)
        
        self.questionModel.isDeleteQuestion
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if let index = owner.questionList.value.firstIndex(where: { element in
                    element.id == value
                }) {
                    var temp = owner.questionList.value
                    temp.remove(at: index)
                    owner.questionList.accept(temp)
                }
            }).disposed(by: disposeBag)
        
        TabbarViewController.tabBarTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if value == 3 {
                    owner.questionModel.readAllQuestions()
                }
            }).disposed(by: disposeBag)
        return output
    }
}
