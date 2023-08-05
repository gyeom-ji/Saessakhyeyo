//
//  ReadQuestionViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/02.
//

import Foundation
import RxCocoa
import RxSwift

final class ReadQuestionViewModel {
    struct Input {
        let backBtnTap: Observable<Void>
        let editBtnTap: Observable<Bool>
        let deleteBtnTap: Observable<Bool>
        
        // comment
        let commentEditBtnTap: Observable<Comment>
        let commentDeleteBtnTap: Observable<Int>
        let commentInsertBtnTap: Observable<Void>
        let commentCancelBtnTap: Observable<Void>
        let commentSaveBtnTap: Observable<String>
    }

    struct Output {
        let didLoadCommentData = BehaviorRelay<Bool>(value: false)
        let showInsertCommentView = PublishRelay<Bool>()
        let showEditCommentView = PublishRelay<String>()
        let hideKeyboard = PublishRelay<Bool>()
        let dismissView = PublishRelay<Bool>()
        let presentUpdateView = PublishRelay<Bool>()
        let updateCommentRow = PublishRelay<Int>()
        
        // Question
        let questionContent = BehaviorRelay<String>(value: "")
        let userName = BehaviorRelay<String>(value: "")
        let category = BehaviorRelay<String>(value: "")
        let dateTime = BehaviorRelay<String>(value: "")
        let imgData = BehaviorRelay<Int>(value: -1)
        let commentCnt = BehaviorRelay<String>(value: "")
        let isHiddenEditBtn = BehaviorRelay<Bool>(value: false)
    }
    
    let userId = UserDefaults.shared.integer(forKey: "id")
    var question: Question?
    var comment: Comment?
    var commentList: [Comment] = []
    var isUpdateComment = false
    
    private let questionModel = QuestionModel.shared
    init(){}
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.backBtnTap
            .subscribe(onNext: {
               output.dismissView.accept(true)
            }).disposed(by: disposeBag)
        
        input.editBtnTap
            .subscribe(onNext: { value in
                output.presentUpdateView.accept(value)
            }).disposed(by: disposeBag)
        
        input.deleteBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.questionModel.deleteQuestion(questionId: owner.question!.id)
                output.dismissView.accept(value)
            }).disposed(by: disposeBag)
        
        input.commentInsertBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.isUpdateComment = false
                output.showInsertCommentView.accept(false)
            }).disposed(by: disposeBag)
        
        input.commentCancelBtnTap
            .subscribe(onNext: {
                output.hideKeyboard.accept(true)
                output.showInsertCommentView.accept(true)
            }).disposed(by: disposeBag)
        
        input.commentSaveBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if owner.isUpdateComment {
                    owner.questionModel.updateComment(commentId: owner.comment!.id, content: value)
                } else {
                    owner.questionModel.insertComment(userId: owner.userId, content: value, questionId: owner.question!.id)
                }
                output.hideKeyboard.accept(true)
                output.showInsertCommentView.accept(true)
            }).disposed(by: disposeBag)
        
        input.commentEditBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.isUpdateComment = true
                owner.comment = value
                output.showEditCommentView.accept(value.content)
            }).disposed(by: disposeBag)
        
        input.commentDeleteBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.questionModel.deleteComment(commentId: value)
                output.showInsertCommentView.accept(true)
            }).disposed(by: disposeBag)
        
        self.questionModel.question
            .withUnretained(self)
            .filter({ owner, value -> Bool in
                value.id != -1
            })
            .subscribe(onNext: { owner, value in
                owner.question = value
                owner.questionModel.readComment(questionId: value.id)
                output.isHiddenEditBtn.accept(!(owner.userId == value.userId))
                output.questionContent.accept(value.content)
                output.userName.accept(value.userName)
                output.category.accept(value.category)
                output.dateTime.accept(value.dateTime)
                output.commentCnt.accept("\(value.commentCnt)")
                output.imgData.accept(value.isImg ? value.id : -1)
            }).disposed(by: disposeBag)
        
        self.questionModel.updateQuestion
            .withUnretained(self)
            .filter({ owner, value -> Bool in
                value.id != -1
            })
            .subscribe(onNext: { owner, value in
                owner.question = value
                owner.questionModel.readComment(questionId: value.id)
                output.isHiddenEditBtn.accept(!(owner.userId == value.userId))
                output.questionContent.accept(value.content)
                output.userName.accept(value.userName)
                output.category.accept(value.category)
                output.dateTime.accept(value.dateTime)
                output.commentCnt.accept("\(value.commentCnt)")
                output.imgData.accept(value.isImg ? value.id : -1)
            }).disposed(by: disposeBag)
        
        self.questionModel.updateComment
            .withUnretained(self)
            .filter({ owner, value -> Bool in
                value.id != -1
            })
            .subscribe(onNext: { owner, value in
                for i in 0..<owner.commentList.count {
                    if owner.commentList[i].id == value.id {
                        owner.commentList[i] = value
                        output.didLoadCommentData.accept(true)
                        break
                    }
                }
            }).disposed(by: disposeBag)
        
        self.questionModel.comment
            .withUnretained(self)
            .filter({ owner, value -> Bool in
                value.id != -1
            })
            .subscribe(onNext: { owner, value in
                owner.commentList.append(value)
                owner.question?.commentCnt += 1
                output.commentCnt.accept("\(owner.question?.commentCnt ?? 0)")
                output.didLoadCommentData.accept(true)
            }).disposed(by: disposeBag)
        
        self.questionModel.isDeleteComment
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if let index = owner.commentList.firstIndex(where: { element in
                    element.id == value
                }) {
                    owner.commentList.remove(at: index)
                }
                owner.question?.commentCnt -= 1
                output.commentCnt.accept("\(owner.question?.commentCnt ?? 0)")
                output.didLoadCommentData.accept(true)
            }).disposed(by: disposeBag)
        
        self.questionModel.commentList
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.commentList = value
                output.didLoadCommentData.accept(true)
            }).disposed(by: disposeBag)
        
        return output
    }
}
