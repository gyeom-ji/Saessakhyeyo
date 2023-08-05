//
//  SettingViewController.swift
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

class SettingViewController: UIViewController {
    
    private lazy var guideBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "guideRewatchLogo"), for: .normal)
        return button
    }()
    
    private var settingLogoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "settingLogo")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private var topBarImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "bar")
        return imgView
    }()
    
    private var bottomBarImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "bar")
        return imgView
    }()
    
    private var locationImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "accept_location")
        return imgView
    }()
    
    private var alarmImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "accept_alarm")
        return imgView
    }()
    
    private lazy var settingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .saessakDarkGreen
        label.text = """
위치를 허용하지 않을 시
서울 기준으로 지역 설정돼요
(식물별 날씨 추천에 사용)
"""
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var saesakImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "saesakhaeyo")
        return imgView
    }()
    
    private lazy var locationSwitch: UISwitch = {
        let activeSwitch = UISwitch()
        activeSwitch.onTintColor = .saessakDarkGreen
        activeSwitch.tintColor = .saessakBeige
        return activeSwitch
    }()
    
    private lazy var alarmSwitch: UISwitch = {
        let activeSwitch = UISwitch()
        activeSwitch.onTintColor = .saessakDarkGreen
        activeSwitch.tintColor = .saessakBeige
        return activeSwitch
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    
    private let disposeBag = DisposeBag()
    var sideVM: SettingViewModel?
    
    private var diaryCellTap = PublishRelay<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setView()
        bindVM()
    }
}

extension SettingViewController {
    
    private func setView(){
        
        view.backgroundColor = .saessakBeige
        view.addSubview(settingLogoImgView)
        settingLogoImgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(65)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(45)
        }
        
        view.addSubview(topBarImgView)
        topBarImgView.snp.makeConstraints { (make) in
            make.top.equalTo(settingLogoImgView.snp.bottom)
            make.width.equalToSuperview()
        }
        
        view.addSubview(locationImgView)
        locationImgView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(topBarImgView.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(45)
        }
        
        view.addSubview(locationSwitch)
        locationSwitch.snp.makeConstraints { (make) in
            make.leading.equalTo(locationImgView.snp.trailing).offset(20)
            make.centerY.equalTo(locationImgView.snp.centerY)
        }
        
        view.addSubview(alarmImgView)
        alarmImgView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(locationImgView.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(45)
        }
        
        view.addSubview(alarmSwitch)
        alarmSwitch.snp.makeConstraints { (make) in
            make.leading.equalTo(alarmImgView.snp.trailing).offset(20)
            make.centerY.equalTo(alarmImgView.snp.centerY)
        }
        
        view.addSubview(guideBtn)
        guideBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        view.addSubview(saesakImgView)
        saesakImgView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(60)
        }
        
        view.addSubview(bottomBarImgView)
        bottomBarImgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(saesakImgView.snp.top)
            make.width.equalToSuperview()
        }
        
        view.addSubview(settingLabel)
        settingLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(bottomBarImgView.snp.top).offset(-10)
        }
    }
    
    private func bindVM(){
        self.sideVM = SettingViewModel()
        let input = SettingViewModel.Input(
            isActiveAlarmSwitch: self.alarmSwitch.rx.isOn.asObservable(),
            isActiveLocationSwitch: self.locationSwitch.rx.isOn.asObservable(),
            guideBtnTap: self.guideBtn.rx.tap.asObservable())
        
        let output = self.sideVM!.transform(from: input, disposeBag: self.disposeBag)
        
        output.isActiveAlarm
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { value in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }).disposed(by: disposeBag)
        
        output.isActiveLocation
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { value in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }).disposed(by: disposeBag)
        
        output.presentGuideView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.presentGuideView()
            }).disposed(by: disposeBag)
    }
    
    func presentGuideView(){
        let vc = GuideViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SettingViewController: CLLocationManagerDelegate{
    
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            locationSwitch.isOn = true
            self.locationManager.startUpdatingLocation() // 중요!
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            getLocationUsagePermission()
        case .denied:
            print("GPS 권한 요청 거부됨")
            locationSwitch.isOn = false
            getLocationUsagePermission()
        default:
            print("GPS: Default")
        }
    }
}
