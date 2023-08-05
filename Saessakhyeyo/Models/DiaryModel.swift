//
//  DiaryModel.swift
//  FirstProject
//
//  Created by 윤겸지 on 2022/10/18.
//

import Foundation
import UIKit
import Alamofire
import RxCocoa
import RxSwift

struct DiaryModel {
    static let shared = DiaryModel()
    
    var updateDiary = BehaviorSubject<Diary>(value: Diary())
    var diary = BehaviorSubject<Diary>(value: Diary())
    var diaryList = BehaviorRelay<[Diary]>(value: [])
    var allPlantdiaryList = BehaviorRelay<[Diary]>(value: [])
    var recentDiaryList = BehaviorRelay<[Diary]>(value: [])
    var isDelete = PublishSubject<Int>()
    
    private init(){}
    private let disposeBag = DisposeBag()
    
    func imageDownload(diaryId: Int, completion: @escaping(Data) -> Void){
        let url = APIConstrants.baseURL+"/diaries/readImage/\(diaryId)"
      
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<Data>(url: URL(string: url)!, method: .get, headers: header)
        
        NetworkManager.shared.getImg(resource: resource)
            .subscribe(onNext:  { result in
                completion(result)
            }).disposed(by: disposeBag)
    }
    
    func readRecentDiary(plantId:Int)
    {
        let url = APIConstrants.baseURL+"/diaries/readDiaryByRecent/\(plantId)"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<[Diary]>(url: URL(string: url)!, method: .get, headers: header)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                self.recentDiaryList.accept(result)
            }).disposed(by: disposeBag)
    }
    
    func readDiaryAll(userId:Int)
    {
        let url = APIConstrants.baseURL+"/diaries/readDiaryList/\(userId)"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<[Diary]>(url: URL(string: url)!, method: .get, headers: header)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                self.allPlantdiaryList.accept(result)
            }).disposed(by: disposeBag)
    }
    
    func readDiaryList(plantId:Int)
    {
        let url = APIConstrants.baseURL+"/diaries/readDiaryByPlant/\(plantId)"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<[Diary]>(url: URL(string: url)!, method: .get, headers: header)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                self.diaryList.accept(result)
            }).disposed(by: disposeBag)
    }
    
    func deleteDiary(diaryId:Int)
    {
        let url = APIConstrants.baseURL+"/diaries/deleteDiary/\(diaryId)"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let resource = Resource<Bool>(url: URL(string: url)!, method: .delete, headers: header)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                self.isDelete.onNext(diaryId)
            }).disposed(by: disposeBag)
    }
    
    func updateDiary(diary: Diary)
    {
        let url = APIConstrants.baseURL+"/diaries/updateDiary/\(diary.id)"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let body : Parameters = [
            "content" : diary.content,
            "weather" : diary.weather,
            "cond": diary.cond,
            "activity1": diary.activity1,
            "activity2": diary.activity2,
            "activity3": diary.activity3,
            "myplant_id": diary.myPlantId,
            "img" : diary.isImg
        ]
        
        let resource = Resource<Bool>(url: URL(string: url)!, method: .put, headers: header, body: body)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                
                if diary.isImg {
                    insertImgDiary(diaryId: diary.id, imgPath: diary.imgData!) {
                        result in
                        self.updateDiary.onNext(diary)
                    }
                } else {
                    self.updateDiary.onNext(diary)
                }
            }).disposed(by: disposeBag)
    }
    
    func insertDiary(userId: Int, diary: Diary)
    {
        let url = APIConstrants.baseURL+"/diaries/createDiary"
        
        let header : HTTPHeaders = ["Content-Type" : "application/json" ]
        
        let body : Parameters = [
            "user_id" : userId,
            "date" : diary.date,
            "time" : diary.time,
            "content" : diary.content,
            "weather" : diary.weather,
            "cond": diary.cond,
            "activity1": diary.activity1,
            "activity2": diary.activity2,
            "activity3": diary.activity3,
            "myplant_id": diary.myPlantId
        ]
        print(body)
        let resource = Resource<Diary>(url: URL(string: url)!, method: .post, headers: header, body: body)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext:  { result in
                if diary.isImg {
                    insertImgDiary(diaryId: result.id, imgPath: diary.imgData!){
                        value in
                        var temp = result
                        temp.imgData = diary.imgData!
                        temp.isImg = true
                        self.diary.onNext(temp)
                    }
                } else {
                    self.diary.onNext(result)
                }
            }).disposed(by: disposeBag)
    }
    
    func insertImgDiary(diaryId: Int, imgPath: Data, completion: @escaping(Bool) -> Void)
    {
        
        let url = APIConstrants.baseURL + "/diaries/createImage"
        
        let headers: Alamofire.HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "identifier": "819efbc3-71fc-11ec-abfa-dd40b1881f4c"
        ]
        
        let resource = Resource<Bool>(url: URL(string: url)!, method: .post, headers: headers, imgPath: imgPath, fileName: diaryId)
        
        NetworkManager.shared.getUpload(resource: resource)
            .subscribe(onNext:  { result in
                completion(result)
            }).disposed(by: disposeBag)
    }
}
