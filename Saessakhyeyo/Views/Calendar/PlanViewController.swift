//
//  PlanViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/30.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

class PlanViewController: UIViewController {

    static var identifier: String {
        return String(describing: Self.self)
    }
    
    init(viewMode: ViewMode){
        self.planVM.viewMode = viewMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumInteritemSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.allowsMultipleSelection = false
        collectionView.register(
            DiaryIconCollectionViewCell.self,
            forCellWithReuseIdentifier: DiaryIconCollectionViewCell.identifier
        )
        collectionView.layer.borderColor = UIColor.saessakBeige.cgColor
        collectionView.layer.borderWidth = 3
        collectionView.layer.cornerRadius = 15
        return collectionView
    }()
    
    private lazy var isDoneSwitch: UISwitch = {
        let activeSwitch = UISwitch()
        activeSwitch.onTintColor = .saessakDarkGreen
        activeSwitch.tintColor = .saessakBeige
        return activeSwitch
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .saessakGray
        label.text = "날짜"
        label.textAlignment = .left
        return label
    }()
    
    private lazy var planDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.layer.cornerRadius = 15
        picker.backgroundColor = .saessakBeige
        picker.tintColor = .saessakGreen
        picker.locale = Locale(identifier:"ko_KR")
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.layer.cornerRadius = 15
        return picker
    }()
    
    private lazy var planLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .saessakGray
        label.text = "일정"
        label.textAlignment = .left
        return label
    }()
    
    private lazy var doneSettingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = .saessakGray
        label.text = "일정 완료 설정"
        label.textAlignment = .left
        return label
    }()
    
    private lazy var alertView = CustomAlertView()
    
    var planVM = PlanViewModel()
    private let disposeBag = DisposeBag()
    private var saveBtnTap = PublishRelay<Bool>()
    private let planIconList = BehaviorRelay<[String]>(value:["water","energy","pruning", "soil"])
    private var selectPlanType = BehaviorRelay<String>(value: "water")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        bindVM()
        bindUI()
    }
}

extension PlanViewController {

    private func setView(){

        view.backgroundColor = .clear

        view.addSubview(alertView)
        alertView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(270)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        contentView.addSubview(planDatePicker)
        planDatePicker.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(planLabel)
        planLabel.snp.makeConstraints { (make) in
            make.top.equalTo(planDatePicker.snp.bottom).offset(20)
            make.leading.equalToSuperview()
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(planLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(60)
        }
        
        contentView.addSubview(doneSettingLabel)
        doneSettingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview()
        }
        
        contentView.addSubview(isDoneSwitch)
        isDoneSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(doneSettingLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func bindUI(){
        alertView.updateUI(alertText: "날짜, 일정, 완료 여부를 선택해주세요", content: contentView)
        
        alertView.saveBtnTap
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.saveBtnTap.accept(true)
                owner.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        alertView.cancelBtnTap
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        planIconList
            .bind(to: collectionView.rx.items(cellIdentifier: DiaryIconCollectionViewCell.identifier, cellType: DiaryIconCollectionViewCell.self)) { index, icon, cell in
                cell.updateUI(img: icon)
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .asDriver()
            .drive(with: self, onNext: { owner, value in owner.selectPlanType.accept(owner.planIconList.value[value.row])
            }).disposed(by: disposeBag)
    }
    
    private func bindVM(){
        let input = PlanViewModel.Input(
            saveBtnTap: self.saveBtnTap.asObservable(),
            selectPlanDate: self.planDatePicker.rx.date.asObservable(),
            selectPlanType: self.selectPlanType.asObservable(),
            isActiveSwitch: self.isDoneSwitch.rx.isOn.asObservable())
        
        let output = self.planVM.transform(from: input, disposeBag: self.disposeBag)
        
        output.planDate
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.planDatePicker.date = value
            }).disposed(by: disposeBag)
        
        output.isActive
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.isDoneSwitch.isOn = value
            }).disposed(by: disposeBag)
        
        output.planType
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, value in
                let row = (value == "soil" ? 3 : value == "energy" ? 1 : value == "pruning" ? 2 : 0)
                owner.collectionView.selectItem(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            }).disposed(by: disposeBag)
    }
}
