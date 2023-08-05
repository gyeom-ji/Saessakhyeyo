//
//  WateringViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/07.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

class WateringViewController: UIViewController {

    init(myPlantVM: MyPlantListViewModel){
        self.myPlantVM = myPlantVM
        print("init")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            WateringTableViewCell.self,
            forCellReuseIdentifier: WateringTableViewCell.identifier
        )
        tableView.separatorStyle = .singleLine
        return tableView
    }()

    private lazy var alertView = CustomAlertView()
    
    var myPlantVM: MyPlantListViewModel?
    private let disposeBag = DisposeBag()
    private var wateringPlantValue = [Bool]()
    var wateringPlantList = PublishRelay<[Bool]>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        bindUI()
    }
}

extension WateringViewController {

    private func setView(){

        view.backgroundColor = .clear

        view.addSubview(alertView)
        alertView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        tableView.snp.makeConstraints { (make) in
            make.height.equalTo(200)
            make.width.equalTo(250)
        }
    }

    private func bindUI(){
        alertView.updateUI(alertText: """
물주기를 할 식물들을 선택해주세요
(D-Day 인 식물만 보여집니다)
""", content: tableView)
        
        alertView.saveBtnTap
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.wateringPlantList.accept(owner.wateringPlantValue)
                owner.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        alertView.cancelBtnTap
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        myPlantVM?.dDayPlantList
            .bind(to: tableView.rx.items(cellIdentifier: WateringTableViewCell.identifier, cellType: WateringTableViewCell.self)) { index, myPlant, cell in
                self.wateringPlantValue.append(false)
                
                cell.updateUI(plantNickName: myPlant.nickname, plantImg: myPlant.imgUrl)
                
                cell.selectBtn
                    .withUnretained(self)
                    .subscribe(onNext: { owner, value in
                        owner.wateringPlantValue[index] = value
                    }).disposed(by: self.disposeBag)
                
            }.disposed(by: disposeBag)
    }
}
