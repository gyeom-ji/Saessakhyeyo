//
//  DictViewModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/04.
//

import Foundation
import RxCocoa
import RxSwift

final class DictViewModel {
    
    struct Input {
        let viewWillAppearEvent: Observable<ViewMode>
        let searchBarEditEvent: Observable<String>
        let speciesCellTap: Observable<[Int]>
    }
    
    struct Output {
        let didLoadData = BehaviorRelay<Bool>(value: false)
        let textFieldText = BehaviorRelay<String>(value: "")
        let hideClearBtn = BehaviorRelay<Bool>(value: false)
        let dismissView = PublishRelay<Bool>()
        let presentReadDictView = PublishRelay<Bool>()
    }
    
    var isFiltering: Bool = false
    var viewMode = ViewMode.main
    var dictList : [Dict] = []
    var sectionDict : [SectionDict] = []
    var filterdDict : [Dict] = []
    private var dictModel = PlantDictModel.shared
    
    init(){
        self.dictModel.readAllDicts()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.viewMode = value
            }).disposed(by: disposeBag)
        
        input.searchBarEditEvent
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                if value != "" {
                    output.hideClearBtn.accept(false)
                    
                    owner.isFiltering = true
                    
                    var plantDic :  [PlantDistance] = []
                    owner.filterdDict.removeAll()
                    
                    let isChosungCheck = value.isChosung()
                    if isChosungCheck {
                        owner.filterdDict = owner.dictList.filter ({
                            // 초성인경우
                            return ($0.plantName.contains(value) || $0.plantName.chosungCheck().contains(value))
                        })} else {
                        owner.filterdDict.removeAll()
                        
                        let checkText = value.matchString(_string: value)
                        if checkText.count > 0 {
                            
                            for i in 0..<owner.dictList.count{
                                if owner.dictList[i].plantName == value {
                                    owner.filterdDict.insert(owner.dictList[i], at: 0)
                                } else if owner.dictList[i].plantName.contains(value) {
                                    owner.filterdDict.append(owner.dictList[i])
                                } else {
                                    let distance = owner.editDistance(first: owner.dictList[i].plantName, second: value)
                                    plantDic.append(PlantDistance(dict: owner.dictList[i], distance: distance))
                                }
                            }
                            
                            if owner.filterdDict.count < 1 {
                                plantDic.sort(by: {$0.distance < $1.distance})
                                for i in 0..<5 {
                                    owner.filterdDict.append(plantDic[i].dict)
                                }
                            }
                        }
                    }
                } else {
                    self.isFiltering = false
                    output.hideClearBtn.accept(true)
                    output.didLoadData.accept(true)
                }
                output.didLoadData.accept(true)
                
            }).disposed(by: disposeBag)
        
        input.speciesCellTap
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.dictModel.dict.onNext(value[0] == 0 ? owner.sectionDict[value[1]].dict[value[2]] : owner.filterdDict[value[2]])
                
                if owner.viewMode == .main {
                    output.presentReadDictView.accept(true)
                } else {
                    output.dismissView.accept(true)
                }
            }).disposed(by: disposeBag)
        
        self.dictModel.sectionList
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.sectionDict = value
                output.didLoadData.accept(true)
            }).disposed(by: disposeBag)
        
        self.dictModel.dictList
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.dictList = value
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func editDistance(first: String, second: String) -> Double{
        let m = first.count + 1
        let n = second.count + 1
        var distance = [[Double]](repeating: [Double](repeating: 0, count: m), count: n)
        
        for i in 1..<m {
            distance[0][i] = distance[0][i-1] + 1
        }
        
        for j in 1..<n {
            distance[j][0] = distance[j-1][0] + 1
        }
        
        for i in 1..<n {
            for j in 1..<m {
                var cost = 0.0
                
                if first[j - 1] != second[i - 1] {
                    cost = 1.0
                }
                distance[i][j] = min(distance[i][j-1] + 1, distance[i-1][j] + 1, distance[i-1][j-1] + cost)
            }
        }
        return distance[n-1][m-1]
    }
}
