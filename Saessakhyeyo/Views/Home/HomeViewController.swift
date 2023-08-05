//
//  HomeViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/06.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import CoreLocation

class HomeViewController: UIViewController {
    
    private lazy var presentPlantListBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: "line.3.horizontal", withConfiguration: config), for: .normal)
        button.tintColor = .saessakDarkGreen
        return button
    }()
    
    private var homeLogoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "saesakhaeyoLogo")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private var weatherImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private var plantImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 85
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    private lazy var plantNickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var presentPlantInfoBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        button.setImage(UIImage(systemName: "exclamationmark.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .saessakDarkGreen
        return button
    }()
    
    private lazy var presentCalendarBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "calendar"), for: .normal)
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .saessakDarkGreen
        label.textAlignment = .center
        return label
    }()
    
    private lazy var ddayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .saessakDarkGreen
        label.textAlignment = .center
        return label
    }()
    
    private lazy var waterBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "watering_can_fill"), for: .normal)
        var menuItems: [UIAction] {
            return [
                UIAction(title: "물주기", image: UIImage(systemName: "drop"), handler: { (_) in self.waterBtnTap.accept(())}),
                UIAction(title: "물주기 취소", image: UIImage(systemName: "arrowshape.turn.up.backward"), handler: { (_) in self.unWaterBtnTap.accept(())}),
            ]
        }
        
        button.menu = UIMenu(image: nil, identifier: nil, options: [], children: menuItems)
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private lazy var wateringImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "watering")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var wateringFillImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "watering_fill")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private var diaryView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.saessakGreen.cgColor
        view.layer.borderWidth = 2.5
        view.layer.cornerRadius = 20
        return view
    }()
    
    private var diaryLogoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "diaryLogo")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var diaryBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        var menuItems: [UIAction] {
            return [
                UIAction(title: "일기 목록", image: UIImage(systemName: "list.dash"), handler: { (_) in self.diaryListBtnTap.accept(())}),
                UIAction(title: "일기 써요", image: UIImage(systemName: "pencil"), handler: { (_) in self.insertDiaryBtnTap.accept(())}),
            ]
        }
        
        button.tintColor = UIColor.saessakDarkGreen
        button.menu = UIMenu(image: nil, identifier: nil, options: [], children: menuItems)
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (self.view.frame.width/3) - 25, height: (self.view.frame.width/3) - 25)
        layout.minimumInteritemSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            DiaryCollectionViewCell.self,
            forCellWithReuseIdentifier: DiaryCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    
    private var planView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.saessakGreen.cgColor
        view.layer.borderWidth = 2.5
        view.layer.cornerRadius = 20
        return view
    }()
    
    private var planLogoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "todayPlanLogo")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            PlanTableViewCell.self,
            forCellReuseIdentifier: PlanTableViewCell.identifier
        )
        tableView.sectionIndexColor = .saessakDarkGreen
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let disposeBag = DisposeBag()
    var homeVM: HomeViewModel?
    
    private var diaryListBtnTap = PublishRelay<Void>()
    private var diaryCellTap = PublishRelay<Int>()
    private var planCellTap = PublishRelay<Int>()
    private var insertDiaryBtnTap = PublishRelay<Void>()
    private var waterBtnTap = PublishRelay<Void>()
    private var unWaterBtnTap = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setView()
        bindVM()
        bindUI()
    }
}

extension HomeViewController {
    
    private func setView(){
        
        wateringImgView.isHidden = true
        wateringFillImgView.isHidden = true
        
        view.backgroundColor = .white
        view.addSubview(homeLogoImgView)
        homeLogoImgView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(45)
        }
        
        view.addSubview(presentPlantListBtn)
        presentPlantListBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(homeLogoImgView.snp.centerY)
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(45)
        }
        
        view.addSubview(plantImgView)
        plantImgView.snp.makeConstraints { (make) in
            make.top.equalTo(homeLogoImgView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(170)
        }
        
        view.addSubview(weatherImgView)
        weatherImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(plantImgView.snp.centerY)
            make.width.height.equalTo(40)
        }
        
        view.addSubview(weatherLabel)
        weatherLabel.snp.makeConstraints { (make) in
            make.top.equalTo(weatherImgView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalTo(plantImgView.snp.leading)
        }
        
        view.addSubview(weatherImgView)
        weatherImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(weatherLabel.snp.centerX)
        }
        
        view.addSubview(presentPlantInfoBtn)
        presentPlantInfoBtn.snp.makeConstraints { (make) in
            make.top.equalTo(plantImgView.snp.top)
            make.trailing.equalTo(plantImgView.snp.trailing)
        }
        
        view.addSubview(presentCalendarBtn)
        presentCalendarBtn.snp.makeConstraints { (make) in
            make.top.equalTo(plantImgView.snp.top).offset(20)
            make.trailing.equalToSuperview().offset(-30)
            make.width.equalTo(55)
            make.height.equalTo(50)
        }
        
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(presentCalendarBtn.snp.centerX)
            make.bottom.equalTo(presentCalendarBtn.snp.bottom).offset(-10)
        }
        
        view.addSubview(wateringFillImgView)
        wateringFillImgView.snp.makeConstraints { (make) in
            make.top.equalTo(presentCalendarBtn.snp.bottom).offset(15)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        view.addSubview(waterBtn)
        waterBtn.snp.makeConstraints { (make) in
            make.top.equalTo(wateringFillImgView.snp.bottom).offset(-15)
            make.trailing.equalToSuperview().offset(-25)
            make.width.equalTo(60)
            make.height.equalTo(50)
        }
        
        view.addSubview(wateringImgView)
        wateringImgView.snp.makeConstraints { (make) in
            make.top.equalTo(waterBtn.snp.bottom).offset(-25)
            make.leading.equalTo(waterBtn.snp.trailing).offset(-20)
            make.width.equalTo(35)
            make.height.equalTo(25)
        }
        
        view.addSubview(ddayLabel)
        ddayLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(waterBtn.snp.centerX)
            make.top.equalTo(waterBtn.snp.bottom)
        }
        
        view.addSubview(plantNickNameLabel)
        plantNickNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(plantImgView.snp.bottom).offset(15)
            make.width.equalToSuperview()
        }
        
        view.addSubview(diaryView)
        diaryView.snp.makeConstraints { (make) in
            make.top.equalTo(plantNickNameLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(190)
        }
        
        diaryView.addSubview(diaryLogoImgView)
        diaryLogoImgView.snp.makeConstraints { (make) in
            make.top.equalTo(diaryView.snp.top).offset(10)
            make.leading.equalTo(diaryView.snp.leading).offset(10)
            make.width.equalTo(90)
            make.height.equalTo(35)
        }
        
        diaryView.addSubview(diaryBtn)
        diaryBtn.snp.makeConstraints { (make) in
            make.top.equalTo(diaryView.snp.top).offset(10)
            make.trailing.equalTo(diaryView.snp.trailing).offset(-20)
        }
        
        diaryView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(diaryLogoImgView.snp.bottom).offset(10)
            make.leading.equalTo(diaryView.snp.leading).offset(10)
            make.trailing.equalTo(diaryView.snp.trailing).offset(-10)
            make.bottom.equalTo(diaryView.snp.bottom).offset(-10)
        }

        view.addSubview(planView)
        planView.snp.makeConstraints { (make) in
            make.top.equalTo(diaryView.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        planView.addSubview(planLogoImgView)
        planLogoImgView.snp.makeConstraints { (make) in
            make.top.equalTo(planView.snp.top).offset(10)
            make.leading.equalTo(planView.snp.leading).offset(10)
            make.width.equalTo(87)
            make.height.equalTo(31)
        }
        
        planView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(planLogoImgView.snp.bottom).offset(5)
            make.trailing.equalTo(planView.snp.trailing).offset(-10)
            make.leading.equalTo(planView.snp.leading).offset(10)
            make.bottom.equalTo(planView.snp.bottom).offset(-10)
        }
    }
    
    private func bindVM(){
        self.homeVM = HomeViewModel()
        let input = HomeViewModel.Input(
            plantInfoBtnTap: self.presentPlantInfoBtn.rx.tap.asObservable(),
            plantListBtnTap: self.presentPlantListBtn.rx.tap.asObservable(),
            calendarBtnTap: self.presentCalendarBtn.rx.tap.asObservable(),
            waterBtnTap: self.waterBtnTap.asObservable(),
            unWaterBtnTap: self.unWaterBtnTap.asObservable(),
            diaryCellTap: self.diaryCellTap.asObservable(),
            insertDiaryBtnTap: self.insertDiaryBtnTap.asObservable(),
            diaryListBtnTap: self.diaryListBtnTap.asObservable(),
            planCellTap: self.planCellTap.asObservable())
        
        let output = self.homeVM!.transform(from: input, disposeBag: self.disposeBag)
        
        output.plantInfo
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, value in
                owner.plantImgView.loadImage(value[1])
                owner.plantNickNameLabel.text = value[0]
            }).disposed(by: disposeBag)
        
        output.weatherInfo
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, value in
                owner.weatherImgView.image = UIImage(named: value[0])
                owner.weatherLabel.setAttributedText(value[1], fontSize: 11, kern: 0, lineSpacing: 5)
                owner.weatherLabel.textAlignment = .center
            }).disposed(by: disposeBag)
        
        output.waterdDayText
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, value in
                owner.ddayLabel.text = value
            }).disposed(by: disposeBag)
        
        output.dateText
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, value in
                owner.dateLabel.text = value
            }).disposed(by: disposeBag)
        
        output.waterChange
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                if value {
                    owner.doWatering()
                } else {
                    owner.undoWatering()
                }
            }).disposed(by: disposeBag)
        
        output.presentPlantListView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.presentPlantListView()
            }).disposed(by: disposeBag)
        
        output.presentPlantInfoView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.presentPlantInfoView()
            }).disposed(by: disposeBag)
        
        output.presentDiaryListView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.presentDiaryListView()
            }).disposed(by: disposeBag)
        
        output.presentDiaryView
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self, onNext: { owner, value in
                owner.presentDiaryView(index: value)
            }).disposed(by: disposeBag)
        
        output.presentCalendarView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.presentCalendarView()
            }).disposed(by: disposeBag)
    }
    
    private func bindUI(){
        homeVM?.diaryList
            .bind(to: collectionView.rx.items(cellIdentifier: DiaryCollectionViewCell.identifier, cellType: DiaryCollectionViewCell.self)) { index, diary, cell in
                
                cell.updateUI(isImg: diary.isImg, activityImg: diary.activity1, conditionImg: diary.cond, diaryId: diary.id, isUpdate: diary.isUpdateImg)
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .asDriver()
            .drive(with: self, onNext: { owner, value in owner.diaryCellTap.accept(value.row)
            }).disposed(by: disposeBag)
        
        homeVM?.planList
            .bind(to: tableView.rx.items(cellIdentifier: PlanTableViewCell.identifier, cellType: PlanTableViewCell.self)) { index, plan, cell in
                
                let planText = plan.planType == "water" ? "물주기" : plan.planType == "energy" ? "영양제주기" : plan.planType == "soil" ? "분갈이 하기" : "가지치기"
                cell.updateUI(plan: "\(plan.myplantName) - \(planText)", isCheck: plan.isDone)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(with: self, onNext: { owner, value in owner.planCellTap.accept(value.row)
            }).disposed(by: disposeBag)
    }
    
    func doWatering() {
        UIView.animate(withDuration: 0.8) {
           
            self.waterBtn.setImage(UIImage(named: "watering_can_fill"), for: .normal)
            self.wateringImgView.isHidden = false
            let rotate = CGAffineTransform(rotationAngle: .pi / 8)
            let scale = CGAffineTransform(scaleX: 1.1, y: 1.1)
            let combine = scale.concatenating(rotate)
            self.waterBtn.transform = combine
            
        } completion: { result in
            let rotate = CGAffineTransform(rotationAngle: .zero)
            let scale = CGAffineTransform(scaleX: 1, y: 1)
            let combine = scale.concatenating(rotate)
            
            self.waterBtn.transform = combine
            self.wateringImgView.isHidden = true
            self.waterBtn.setImage(UIImage(named: "watering_can"), for: .normal)
        }
    }
    
    
    func undoWatering() {
        UIView.animate(withDuration: 0.8) {
            
            self.waterBtn.setImage(UIImage(named: "watering_can"), for: .normal)
            self.wateringFillImgView.isHidden = false
            self.wateringFillImgView.transform = CGAffineTransform(translationX: 0, y: 17)
            
        } completion: { result in

            self.wateringFillImgView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.wateringFillImgView.isHidden = true
            self.waterBtn.setImage(UIImage(named: "watering_can_fill"), for: .normal)
        }
    }
    
    func presentPlantInfoView(){
        let vc = InsertPlantViewController(viewMode: .update)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentDiaryListView(){
        let vc = DiaryListViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentDiaryView(index: Int){
        let vc = DiaryViewController(viewMode: index != -1 ? .update : .create)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentCalendarView(){
        let vc = CalendarViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentPlantListView(){
        let vc = MyPlantListViewController()
        vc.hidesBottomBarWhenPushed = true
        let transition = CATransition()
        transition.duration = 0.45
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
