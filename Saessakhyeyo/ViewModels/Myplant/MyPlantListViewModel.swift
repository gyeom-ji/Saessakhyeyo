//
//  MyPlantListViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/07.
//

import Foundation
import RxCocoa
import RxSwift

class MyPlantListViewModel {
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let backBtnTap: Observable<Void>
        let waterBtnTap: Observable<Void>
        let sortBtnTap: Observable<Void>
        let selectPlant: Observable<Int>
        let deletePlant: Observable<Int>
        let sortMyPlantList: Observable<[Int]> // [0] from [1] to
        let wateringPlant: Observable<[Bool]>
    }
    
    struct Output {
        let presentWateringView = PublishRelay<Bool>()
        let showSortView = PublishRelay<Bool>()
        let dismissView = PublishRelay<Bool>()
    }
    
    let userId = UserDefaults.shared.integer(forKey: "id")
    var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter
    }()
    
    var myPlantList = BehaviorRelay<[Myplant]>(value: [])
    var dDayPlantList = BehaviorRelay<[Myplant]>(value: [])
    var sortPlantList: [Myplant]?
    private let myPlantModel = MyplantModel.shared
    
    init(){}
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlantModel.readPlantList(userId: owner.userId)
            }).disposed(by: disposeBag)
        
        input.backBtnTap
            .subscribe(onNext: {
                output.dismissView.accept(true)
            }).disposed(by: disposeBag)

        input.waterBtnTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.setDdayPlantList()
                output.presentWateringView.accept(true)
            }).disposed(by: disposeBag)
        
        input.selectPlant
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlantModel.myPlant.onNext(owner.myPlantList.value[value])
                output.dismissView.accept(true)
            }).disposed(by: disposeBag)
        
        input.sortBtnTap
            .subscribe(onNext: {
                output.showSortView.accept(true)
            }).disposed(by: disposeBag)
        
        input.sortMyPlantList
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.sortPlantList = owner.myPlantList.value
                let itemToMove = owner.sortPlantList![value[0]]
                owner.sortPlantList!.remove(at: value[0])
                owner.sortPlantList!.insert(itemToMove, at: value[1])
                for i in 0..<owner.sortPlantList!.count {
                    owner.myPlantModel.customSortPlant(plantId: owner.sortPlantList![i].id, order: "\(i)")
                }
            }).disposed(by: disposeBag)
        
        input.deletePlant
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlantModel.deletePlant(plantId: owner.myPlantList.value[value].id)
            }).disposed(by: disposeBag)
        
        input.wateringPlant
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                for i in 0..<value.count {
                    if value[i] {
                        owner.myPlantModel.updatePlant(plantId: owner.myPlantList.value[i].id, type: "date")
                    }
                }
                owner.myPlantModel.readPlantList(userId: owner.userId)
            }).disposed(by: disposeBag)
        
        self.myPlantModel.myPlantList
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.myPlantList.accept(value)
            }).disposed(by: disposeBag)
        
        self.myPlantModel.isDelete
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if let index = owner.myPlantList.value.firstIndex(where: { element in
                    element.id == value
                }) {
                    var temp = owner.myPlantList.value
                    temp.remove(at: index)
                    owner.myPlantList.accept(temp)
                }
            }).disposed(by: disposeBag)
        
        self.myPlantModel.isSort
            .withUnretained(self)
            .filter({ owner, value -> Bool in
                value
            })
            .subscribe(onNext: { owner, value in
                owner.myPlantList.accept(owner.sortPlantList!)
            }).disposed(by: disposeBag)
        
        return output
    }
    
    private func setDdayPlantList(){
        var temp : [Myplant] = []
        for i in 0..<myPlantList.value.count {
            if myPlantList.value[i].dday! == "D-Day" {
                temp.append(myPlantList.value[i])
            }
        }
        dDayPlantList.accept(temp)
    }
}
