//
//  MyPlantListViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/07.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit

class MyPlantListViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            MyPlantTableViewCell.self,
            forCellReuseIdentifier: MyPlantTableViewCell.identifier
        )
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var backBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.right", withConfiguration: config), for: .normal)
        button.tintColor = .saessakDarkGreen
        return button
    }()
    
    private lazy var sortBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: "arrow.up.arrow.down", withConfiguration: config), for: .normal)
        button.tintColor = .saessakDarkGreen
        return button
    }()
    
    private lazy var waterBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "watering_can_fill"), for: .normal)
        return button
    }()
    
    private lazy var myPlantListLogoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "plantListLogo")
        
        return imgView
    }()
    
    private let disposeBag = DisposeBag()
    private var myPlantVM: MyPlantListViewModel?
    var selectPlant = PublishSubject<Int>()
    var deletePlant = PublishSubject<Int>()
    var sortPlant = PublishSubject<[Int]>()
    var wateringPlantList = PublishRelay<[Bool]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setView()
        bindVM()
        bindUI()
    }
    
    private func setView(){
        view.backgroundColor = .white
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        view.addSubview(myPlantListLogoImgView)
        myPlantListLogoImgView.snp.makeConstraints { make in
            make.centerY.equalTo(backBtn.snp.centerY)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(100)
            make.height.equalTo(45)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(backBtn.snp.bottom).offset(15)
            make.trailing.leading.equalToSuperview()
        }
        
        view.addSubview(waterBtn)
        waterBtn.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(15)
            make.trailing.equalToSuperview().offset(-25)
            make.width.equalTo(43)
            make.height.equalTo(33)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        view.addSubview(sortBtn)
        sortBtn.snp.makeConstraints { make in
            make.trailing.equalTo(waterBtn.snp.leading).offset(-10)
            make.height.equalTo(70)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func bindVM(){
        self.myPlantVM = MyPlantListViewModel()
        
        let input = MyPlantListViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in},
            backBtnTap: self.backBtn.rx.tap.asObservable(),
            waterBtnTap: self.waterBtn.rx.tap.asObservable(),
            sortBtnTap: self.sortBtn.rx.tap.asObservable(),
            selectPlant: self.selectPlant.asObserver(),
            deletePlant: self.deletePlant.asObserver(),
            sortMyPlantList: self.sortPlant.asObserver(),
            wateringPlant: self.wateringPlantList.asObservable())
        
        let output = self.myPlantVM!.transform(from: input, disposeBag: self.disposeBag)
        
        output.presentWateringView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.presentWateringView()
            }).disposed(by: disposeBag)
        
        output.showSortView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                if owner.tableView.isEditing {
                    owner.tableView.setEditing(false, animated: true)
                    let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
                    owner.sortBtn.setImage(UIImage(systemName: "arrow.up.arrow.down", withConfiguration: config), for: .normal)
                    
                } else {
                    owner.tableView.setEditing(true, animated: true)
                    let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
                    owner.sortBtn.setImage(UIImage(systemName: "checkmark", withConfiguration: config), for: .normal)
                }
            }).disposed(by: disposeBag)
        
        output.dismissView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                let transition = CATransition()
                transition.duration = 0.45
                transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                owner.navigationController?.view.layer.add(transition, forKey: kCATransition)
                owner.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    
    func presentWateringView() {
        let vc = WateringViewController(myPlantVM: self.myPlantVM!)
        
        vc.modalPresentationStyle = .overFullScreen
        vc.wateringPlantList
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.wateringPlantList.accept(value)
            }).disposed(by: disposeBag)
        
        self.present(vc, animated: true)
        
    }
    
    private func bindUI(){
        myPlantVM?.myPlantList
            .bind(to: tableView.rx.items(cellIdentifier: MyPlantTableViewCell.identifier, cellType: MyPlantTableViewCell.self)) { index, myPlant, cell in
                cell.updateUI(sunCondition: Int(myPlant.sunCondition), windCondition: Int(myPlant.windCondition), waterCondition: Int(myPlant.waterCondition), plantNickName: myPlant.nickname, dday: myPlant.dday!, plantImg: myPlant.imgUrl)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.selectPlant.onNext(value.row)
            }).disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.deletePlant.onNext(value.row)
            }).disposed(by: disposeBag)
        
        tableView.rx.itemMoved
            .asDriver()
            .drive(with: self, onNext: { (owner, path : (sourceIndex: IndexPath, destinationIndex: IndexPath)) in
                owner.sortPlant.onNext([path.sourceIndex.row, path.destinationIndex.row])
            }).disposed(by: disposeBag)
    }
}
