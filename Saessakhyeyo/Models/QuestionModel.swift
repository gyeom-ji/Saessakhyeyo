//
//  QuestionModel.swift
//  FirstProject
//
//  Created by 윤겸지 on 2022/10/09.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

struct QuestionModel {
    
    static let shared = QuestionModel()

    var isDeleteQuestion = PublishSubject<Int>()
    var updateQuestion = BehaviorSubject<Question>(value: Question())
    var question = BehaviorSubject<Question>(value: Question())
    var questionList = BehaviorRelay<[Question]>(value: [])
    var filterdQuestionList = BehaviorRelay<[Question]>(value: [])
    var isDeleteComment = PublishSubject<Int>()
    var comment = BehaviorSubject<Comment>(value: Comment())
    var updateComment = BehaviorSubject<Comment>(value: Comment())
    var commentList = BehaviorSubject<[Comment]>(value: [])

    private init() {}
    private let disposeBag = DisposeBag()
    
    /// Question
    func insertImgQuestion(questionId: Int, imgPath: Data, completion: @escaping(Bool) -> Void)
    {
        let url = APIConstrants.baseURL + "/questions/createImage"
        
        let headers: Alamofire.HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "identifier": "819efbc3-71fc-11ec-abfa-dd40b1881f4c"
        ]
        
        let resource = Resource<Bool>(url: URL(string: url)!, method: .post, headers: headers, imgPath: imgPath, fileName: questionId)
        
        NetworkManager.shared.getUpload(resource: resource)
            .subscribe(onNext:  { result in
                completion(result)
            }).disposed(by: disposeBag)
    }
    
    func insertQuestion(userId: Int, question: Question)
    {
        
        let url = APIConstrants.baseURL+"/questions/createQuestion"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let body : Parameters = [
            "user_id" : userId,
            "content" : question.content,
            "category" : question.category == "" ? "전체" : question.category,
        ]
        
        let resource = Resource<Question>(url: URL(string: url)!, method: .post, headers: header, body: body)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                if question.isImg {
                    insertImgQuestion(questionId: result.id, imgPath: question.imgData!){
                        value in
                        var temp = result
                        temp.imgData = question.imgData!
                        temp.isImg = true
                        self.question.onNext(temp)
                    }
                } else {
                    self.question.onNext(result)
                }
            }).disposed(by: disposeBag)
    }
    
    func deleteQuestion(questionId:Int)
    {
        let url =  APIConstrants.baseURL+"/questions/deleteQuestion/\(questionId)"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<Bool>(url: URL(string: url)!, method: .delete, headers: header)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                isDeleteQuestion.onNext(questionId)
            }).disposed(by: disposeBag)
    }
    
    func updateQuestion(question: Question)
    {
        let url =  APIConstrants.baseURL+"/questions/updateQuestion/\(question.id)"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        let body : Parameters = [
            "content" : question.content,
            "category" : question.category,
            "img" : question.isImg
        ]
        let resource = Resource<Question>(url: URL(string: url)!, method: .put, headers: header, body: body)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                if question.isImg {
                    insertImgQuestion(questionId: result.id, imgPath: question.imgData!){
                        value in
                        self.question.onNext(question)
                    }
                } else {
                    self.question.onNext(result)
                }
            }).disposed(by: disposeBag)
    }

    func readAllQuestions() {
        
        let url = APIConstrants.baseURL+"/questions/readAll"

        let header : HTTPHeaders = ["Content-Type" : "application/json" ]

        let resource = Resource<[Question]>(url: URL(string: url)!, method: .get, headers: header)
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                questionList.accept(result)
            }).disposed(by: disposeBag)
    }
    
    func readDetailQuestion(questionId:Int)
    {
        let url = APIConstrants.baseURL+"/questions/readOne/\(questionId)"
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]

        let resource = Resource<Question>(url: URL(string: url)!, method: .get, headers: header)

        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                self.question.onNext(result)
            }).disposed(by: disposeBag)
        print("readDetailQuestion")
    }
    
    func searchQuestions(content: String, category: String) {
        
        let url = APIConstrants.baseURL+"/questions/search"

        let header : HTTPHeaders = ["Content-Type" : "application/json" ]

        let body : Parameters = [
            "content" : content,
            "category" : category
        ]

        let resource = Resource<[Question]>(url: URL(string: url)!, method: .post, headers: header, body: body)

        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                self.filterdQuestionList.accept(result)
                print(result)
            }).disposed(by: disposeBag)
    }
    
    /// comment
    func insertComment(userId: Int, content: String, questionId:Int)
    {
        let url = APIConstrants.baseURL+"/comments/createComment"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let body : Parameters = [
            "user_id" : userId,
            "content" : content,
            "question_id": questionId
        ]
        let resource = Resource<Comment>(url: URL(string: url)!, method: .post, headers: header, body: body)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                print("=========")
                print(result)
                self.comment.onNext(result)
            }).disposed(by: disposeBag)
    }
    
    func updateComment(commentId:Int, content:String)
    {
        let url = APIConstrants.baseURL+"/comments/updateComment/\(commentId)"

        let header : HTTPHeaders = ["Content-Type" : "application/json" ]

        let body : Parameters = [
            "content" : content
        ]
        let resource = Resource<Comment>(url: URL(string: url)!, method: .put, headers: header, body: body)

        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                self.updateComment.onNext(result)
                print(result)
            }).disposed(by: disposeBag)
    }
    
    func readComment(questionId:Int)
    {
        let url = APIConstrants.baseURL+"/comments/readOne/\(questionId)"

        let header : HTTPHeaders = ["Content-Type" : "application/json" ]

        let resource = Resource<[Comment]>(url: URL(string: url)!, method: .get, headers: header)

        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                self.commentList.onNext(result)
                print(result)
            }).disposed(by: disposeBag)
    }
    
    func deleteComment(commentId:Int)
    {
        let url =  APIConstrants.baseURL+"/comments/deleteComment/\(commentId)"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<Bool>(url: URL(string: url)!, method: .delete, headers: header)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                isDeleteComment.onNext(commentId)
            }).disposed(by: disposeBag)
    }
    
    func imageDownload(questionId: Int, completion: @escaping(Data) -> Void){
        let url = APIConstrants.baseURL+"/questions/readImage/\(questionId)"
      
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<Data>(url: URL(string: url)!, method: .get, headers: header)
        
        NetworkManager.shared.getImg(resource: resource)
            .subscribe(onNext:  { result in
                print(result)
                completion(result)
            }).disposed(by: disposeBag)
    }
}
