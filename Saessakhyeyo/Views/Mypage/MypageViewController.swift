//
//  MypageViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/29.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import CoreLocation
import SideMenu

class MypageViewController: UIViewController {
    
    private lazy var settingBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        button.setImage(UIImage(systemName: "gearshape", withConfiguration: config), for: .normal)
        button.tintColor = .saessakDarkGreen
        return button
    }()
    
    private var myPageLogoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "mypageLogo")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private var userImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()

    private lazy var userNickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .saessakDarkGreen
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var barView: UIView = {
        let view = UIView()
        view.backgroundColor = .saessakBeige
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var diaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .saessakDarkGreen
        return label
    }()

    private lazy var myPlantLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .saessakDarkGreen
        return label
    }()
    
    private lazy var saesakImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "saesak")
        return imgView
    }()
    
    private lazy var saesakImgView2: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "saesak")
        return imgView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (self.view.frame.width/4) - 10, height: (self.view.frame.width/4) - 10)
        layout.minimumInteritemSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            MypageDiaryCollectionViewCell.self,
            forCellWithReuseIdentifier: MypageDiaryCollectionViewCell.identifier
        )
        return collectionView
    }()
   
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .saessakBeige
        return view
    }()
    
    private let disposeBag = DisposeBag()
    var mypageVM: MypageViewModel?

    private var diaryCellTap = PublishRelay<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setView()
        bindVM()
        bindUI()
    }
}

extension MypageViewController {
    
    private func setView(){
    
        view.backgroundColor = .white
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.leading.equalToSuperview()
        }
        
        headerView.addSubview(myPageLogoImgView)
        myPageLogoImgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        view.addSubview(userImgView)
        userImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.width.height.equalTo(150)
        }
        
        view.addSubview(settingBtn)
        settingBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(userImgView.snp.centerY)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        view.addSubview(userNickNameLabel)
        userNickNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(userImgView.snp.bottom)
        }
        
        view.addSubview(barView)
        barView.snp.makeConstraints { (make) in
            make.top.equalTo(userNickNameLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        barView.addSubview(diaryLabel)
        diaryLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        barView.addSubview(saesakImgView)
        saesakImgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(40)
            make.width.equalTo(60)
            make.leading.equalTo(diaryLabel.snp.trailing).offset(20)
        }
        
        barView.addSubview(myPlantLabel)
        myPlantLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(saesakImgView.snp.trailing).offset(20)
        }
        
        barView.addSubview(saesakImgView2)
        saesakImgView2.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(40)
            make.width.equalTo(60)
            make.leading.equalTo(myPlantLabel.snp.trailing).offset(20)
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(barView.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
        }
    }
    
    private func bindVM(){
        self.mypageVM = MypageViewModel()
        let input = MypageViewModel.Input(
            settingBtnTap: self.settingBtn.rx.tap.asObservable(),
            diaryCellTap: self.diaryCellTap.asObservable())
        
        let output = self.mypageVM!.transform(from: input, disposeBag: self.disposeBag)
        
        output.userNameText
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, value in
                owner.userNickNameLabel.text = value
                owner.userImgView.image = UIImage(named: self.getRandomSaessak())
            }).disposed(by: disposeBag)
        
        output.myPlantCount
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self, onNext: { owner, value in
                owner.myPlantLabel.text = "관리 식물     \(value)"
            }).disposed(by: disposeBag)
        
        output.diaryCount
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self, onNext: { owner, value in
                owner.diaryLabel.text = "일기     \(value)"
            }).disposed(by: disposeBag)
        
        output.presentSettingSideMenu
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.presentSettingSideMenu()
            }).disposed(by: disposeBag)
                
        output.presentDiaryView
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self, onNext: { owner, value in
                owner.presentDiaryView(index: value)
            }).disposed(by: disposeBag)
    }
    
    private func bindUI(){
        mypageVM?.diaryList
            .bind(to: collectionView.rx.items(cellIdentifier: MypageDiaryCollectionViewCell.identifier, cellType: MypageDiaryCollectionViewCell.self)) { index, diary, cell in
                cell.updateUI(isImg: diary.isImg, diaryId: diary.id, isUpdate: diary.isUpdateImg)
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.diaryCellTap.accept(value.row)
            }).disposed(by: disposeBag)
    }
    
    func presentDiaryView(index: Int){
        let vc = DiaryViewController(viewMode: index != -1 ? .update : .create)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentSettingSideMenu(){
        let vc = SettingViewController()
        let sideMenuNavigation = SideMenuNavigationController(rootViewController: vc)
        sideMenuNavigation.presentationStyle = .menuSlideIn
        sideMenuNavigation.presentDuration = 1.0
        sideMenuNavigation.dismissDuration = 1.0
        present(sideMenuNavigation, animated: true)
    }
    
    func getRandomSaessak() -> String {
        let saessak = ["saesak_basics", "saesak_merong", "saesak_smile", "saesak_teeth", "saesak_wink"]
        return saessak.randomElement()!
    }
}
