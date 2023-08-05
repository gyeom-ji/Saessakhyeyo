//
//  InsertPlantViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/05.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import CoreLocation

class InsertPlantViewController: UIViewController {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    init(viewMode: ViewMode){
        self.viewMode = viewMode
        self.myPlantVM.viewMode = viewMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var plantNickNameLabelConstraint: ConstraintMakerEditable?
    private var tempViewConstraint: Constraint?
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    
    private lazy var waterSliderview: UIView = {
        let view = CustomSliderView()
        view.img = "drop"
        return view
    }()
    
    private lazy var sunSliderview: UIView = {
        let view = CustomSliderView()
        view.img = "sun.min"
        return view
    }()
    
    private lazy var windSliderview: UIView = {
        let view = CustomSliderView()
        view.img = "wind"
        return view
    }()
    
    private lazy var searchBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        button.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: config), for: .normal)
        button.setTitle(" 식물을 선택해주세요", for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = .saessakDarkGreen
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.setTitleColor(.saessakDarkGreen, for: .normal)
        button.backgroundColor = .saessakBeige
        
        return button
    }()
    
    private var plantImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 60
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    private lazy var plantSpeciesTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.textColor = .darkGray
        textField.textAlignment = .center
        textField.placeholder = "식물 종을 검색하거나 직접 입력해주세요"
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.saessakBeige.cgColor
        textField.layer.borderWidth = 2
        textField.becomeFirstResponder()
        
        return textField
    }()
    
    private lazy var plantNickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .saessakGray
        label.text = "식물 별명"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var plantNickNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 13)
        textField.textAlignment = .center
        textField.placeholder = "식물 별명을 입력해주세요"
        textField.textColor = .darkGray
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.saessakBeige.cgColor
        textField.layer.borderWidth = 2
        
        return textField
    }()
    
    private lazy var waterCycleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .saessakGray
        label.text = "물주는 주기"
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var waterCycleBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        button.setImage(UIImage(systemName: "drop.fill", withConfiguration: config), for: .normal)
        button.setTitle(" 물주는 주기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.layer.cornerRadius = 10
        button.backgroundColor = .saessakDarkGreen
        button.tintColor = .white
        return button
    }()
    
    private lazy var latestWaterDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .saessakGray
        label.text = "마지막 물준날"
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var latestWaterDatePicker: UIDatePicker = {
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
    
    private lazy var plantRegionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .saessakGray
        label.text = """
식물 위치
(날씨 추천에 사용합니다.)
"""
        label.textAlignment = .left
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var plantRegionBtn: UIButton = {
        let button = UIButton()
        button.setTitle("  식물 위치  ", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.cornerRadius = 10
        button.backgroundColor = .saessakDarkGreen
        button.tintColor = .white
        return button
    }()
    
    private lazy var sunLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .saessakGray
        label.text = "일조량"
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var sunSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        slider.thumbTintColor = .clear
        slider.value = 1
        slider.minimumValue = 0
        slider.maximumValue = 5
        return slider
    }()
    
    private lazy var windLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .saessakGray
        label.text = "풍량"
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var windSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        slider.thumbTintColor = .clear
        slider.value = 1
        slider.minimumValue = 0
        slider.maximumValue = 5
        
        return slider
    }()
    
    private lazy var waterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .saessakGray
        label.text = "물주는 양"
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var waterSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        slider.thumbTintColor = .clear
        slider.value = 1
        slider.minimumValue = 0
        slider.maximumValue = 5
        
        return slider
    }()
    
    private lazy var waterRecommandLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var activeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .saessakGray
        label.text = "활성화 설정"
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var activeSwitch: UISwitch = {
        let activeSwitch = UISwitch()
        activeSwitch.onTintColor = .saessakDarkGreen
        activeSwitch.tintColor = .saessakBeige
        
        return activeSwitch
    }()
    
    private lazy var saveBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "save")?.resizeImageTo(size: CGSize(width: 50, height: 50)), for: .normal)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var tempView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var backBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.forward", withConfiguration: config), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .saessakDarkGreen
        return button
    }()
    
    private lazy var deleteBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "trashIcon"), for: .normal)
        return button
    }()
    
    private var viewMode = ViewMode.create
    private let disposeBag = DisposeBag()
    var myPlantVM = InsertPlantViewModel()
    private var focusedRow = Int()
    private var selectRegion = PublishRelay<[String]>()
    private var selectWaterCycle = BehaviorRelay<Int>(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setView()
        bindGesture(disposeBag: disposeBag)
        bindVM()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension InsertPlantViewController {
    
    private func setView(){
        
        hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .white
        view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(60)
            make.trailing.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(45)
        }
        
        if viewMode == .create {
            view.addSubview(searchBtn)
            searchBtn.snp.makeConstraints { (make) in
                make.top.equalTo(saveBtn.snp.bottom).offset(8)
                make.leading.equalToSuperview().offset(60)
                make.trailing.equalToSuperview().offset(-60)
                make.height.equalTo(40)
            }
            
            view.addSubview(scrollView)
            scrollView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
                make.top.equalTo(searchBtn.snp.bottom)
            }
        } else {
            view.addSubview(backBtn)
            backBtn.snp.makeConstraints { (make) in
                make.centerY.equalTo(saveBtn.snp.centerY)
                make.leading.equalToSuperview().offset(10)
            }
            
            view.addSubview(scrollView)
            scrollView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
                make.top.equalTo(backBtn.snp.bottom).offset(10)
            }
        }
        
        scrollView.addSubview(plantImgView)
        plantImgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        scrollView.addSubview(plantSpeciesTextField)
        plantSpeciesTextField.snp.makeConstraints { (make) in
            make.top.equalTo(plantImgView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-100)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(plantNickNameLabel)
        plantNickNameLabel.snp.makeConstraints { (make) in
            plantNickNameLabelConstraint = make.top.equalTo(plantSpeciesTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        scrollView.addSubview(plantNickNameTextField)
        plantNickNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(plantNickNameLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-100)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(waterCycleLabel)
        waterCycleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(plantNickNameTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        scrollView.addSubview(waterCycleBtn)
        waterCycleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(waterCycleLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        scrollView.addSubview(latestWaterDateLabel)
        latestWaterDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(waterCycleBtn.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        scrollView.addSubview(latestWaterDatePicker)
        latestWaterDatePicker.snp.makeConstraints { (make) in
            make.top.equalTo(latestWaterDateLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        scrollView.addSubview(plantRegionLabel)
        plantRegionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(latestWaterDatePicker.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        scrollView.addSubview(plantRegionBtn)
        plantRegionBtn.snp.makeConstraints { (make) in
            make.top.equalTo(plantRegionLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        scrollView.addSubview(sunLabel)
        sunLabel.snp.makeConstraints { (make) in
            make.top.equalTo(plantRegionBtn.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
        }
        
        scrollView.addSubview(sunSliderview)
        sunSliderview.snp.makeConstraints { (make) in
            make.top.equalTo(sunLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        scrollView.addSubview(sunSlider)
        sunSlider.snp.makeConstraints { (make) in
            make.centerY.equalTo(sunSliderview.snp.centerY)
            make.centerX.equalToSuperview()
            make.width.equalTo(sunSliderview.snp.width)
        }
        
        scrollView.addSubview(windLabel)
        windLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sunSliderview.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
        }
        
        scrollView.addSubview(windSliderview)
        windSliderview.snp.makeConstraints { (make) in
            make.top.equalTo(windLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        scrollView.addSubview(windSlider)
        windSlider.snp.makeConstraints { (make) in
            make.centerY.equalTo(windSliderview.snp.centerY)
            make.centerX.equalToSuperview()
            make.width.equalTo(windSliderview.snp.width)
        }
        
        scrollView.addSubview(waterLabel)
        waterLabel.snp.makeConstraints { (make) in
            make.top.equalTo(windSliderview.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
        }
        
        scrollView.addSubview(waterSliderview)
        waterSliderview.snp.makeConstraints { (make) in
            make.top.equalTo(waterLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        scrollView.addSubview(waterSlider)
        waterSlider.snp.makeConstraints { (make) in
            make.centerY.equalTo(waterSliderview.snp.centerY)
            make.centerX.equalToSuperview()
            make.width.equalTo(waterSliderview.snp.width)
        }
        
        scrollView.addSubview(waterRecommandLabel)
        waterRecommandLabel.snp.makeConstraints { (make) in
            make.top.equalTo(waterSliderview.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        scrollView.addSubview(activeLabel)
        activeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(waterRecommandLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        scrollView.addSubview(activeSwitch)
        activeSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(activeLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(70)
        }
        
        if viewMode == .update {
            scrollView.addSubview(deleteBtn)
            deleteBtn.snp.makeConstraints { (make) in
                make.trailing.equalTo(saveBtn.snp.trailing).offset(-15)
                make.top.equalTo(activeSwitch.snp.bottom)
                make.width.equalTo(52)
                make.height.equalTo(50)
            }
        }
        
        scrollView.addSubview(tempView)
        tempView.snp.makeConstraints { (make) in
            make.top.equalTo(activeSwitch.snp.bottom)
            tempViewConstraint = make.height.equalTo(30).constraint
            make.bottom.equalToSuperview().offset(-34)
        }
    }
    
    private func bindVM(){
        let input = InsertPlantViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { [self] _ in viewMode},
            backBtnTap: self.backBtn.rx.tap.asObservable(),
            searchBtnTap: self.searchBtn.rx.tap.asObservable(),
            saveBtnTap: self.saveBtn.rx.tap.asObservable().map { _ in },
            regionBtnTap: self.plantRegionBtn.rx.tap.asObservable(),
            selectRegion: self.selectRegion.asObservable(),
            waterCycleBtnTap: self.waterCycleBtn.rx.tap.asObservable(),
            selectWaterCycle: self.selectWaterCycle.asObservable(),
            waterSliderDrag: self.waterSlider.rx.value.asObservable(),
            windSliderDrag:self.windSlider.rx.value.asObservable(),
            sunSliderDrag: self.sunSlider.rx.value.asObservable(),
            isActiveSwitch: self.activeSwitch.rx.isOn.asObservable(),
            selectLatestDate: self.latestWaterDatePicker.rx.date.asObservable(),
            textFieldEdit: self.plantNickNameTextField.rx.text.orEmpty.asObservable()
        )
        
        let output = self.myPlantVM.transform(from: input, disposeBag: self.disposeBag)
        
        output.plantImg
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                if value == "saesak_basics" {
                    owner.plantImgView.image = UIImage(named: "saesak_basics")?.resizeImageTo(size: CGSize(width: 110, height: 120))
                } else {
                    owner.plantImgView.loadImage(value)
                }
                owner.getLocationUsagePermission()
            })
            .disposed(by: disposeBag)
        
        output.plantSpecies
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.plantSpeciesTextField.text = value
            })
            .disposed(by: disposeBag)
        
        output.waterRec
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.waterRecommandLabel.text = value
            }).disposed(by: disposeBag)
        
        output.region
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.plantRegionBtn.setTitle("  식물 위치 : \(value)  ", for: .normal)
            }).disposed(by: disposeBag)
        
        output.presentSearchView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.presentSearchView()
            }).disposed(by: disposeBag)
        
        output.presentRegionView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.presentRegionView()
            }).disposed(by: disposeBag)
        
        output.presentWaterCycleView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.showWaterCycleAlert()
            }).disposed(by: disposeBag)
        
        output.waterCycle
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.waterCycleBtn.setTitle("  물주는 주기 : \(value)", for: .normal)
            }).disposed(by: disposeBag)
        
        output.waterSlider
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                let floatValue = floor(value * 10) / 10
                
                for index in 0...5 {
                    if let waterImg = owner.waterSliderview.viewWithTag(index) as? UIImageView {
                        waterImg.tintColor = .waterBlue
                        if Float(index) <= floatValue {
                            waterImg.image = UIImage(systemName: "drop.fill" )
                        } else {
                            waterImg.image = UIImage(systemName: "drop" )
                        }
                    }
                }
                
            }).disposed(by: disposeBag)
        
        output.sunSlider
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                let floatValue = floor(value * 10) / 10
                
                for index in 0...5 {
                    if let sunImage = owner.sunSliderview.viewWithTag(index) as? UIImageView {
                        sunImage.tintColor = .sunRed
                        if Float(index) <= floatValue {
                            sunImage.image = UIImage(systemName: "sun.min.fill" )
                        }  else {
                            sunImage.image = UIImage(systemName: "sun.min" )
                        }
                    }
                }
            }).disposed(by: disposeBag)
        
        output.windSlider
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                let floatValue = floor(value * 10) / 10
                
                for index in 0...5 {
                    if let windImage = owner.windSliderview.viewWithTag(index) as? UIImageView {
                        if Float(index) <= floatValue {
                            windImage.tintColor = .windFullBlue
                            windImage.image =  UIImage(systemName: "wind")
                        } else {
                            windImage.tintColor = .windBlue
                            windImage.image = UIImage(systemName: "wind")
                        }
                    }
                }
                
            }).disposed(by: disposeBag)
        
        output.dismissView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        output.plantNickName
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, value in
                owner.plantNickNameTextField.text = value
            }).disposed(by: disposeBag)
        
        output.latestWaterDate
            .asDriver(onErrorJustReturn: Date())
            .drive(with: self, onNext: { owner, value in
                owner.latestWaterDatePicker.date = value
            }).disposed(by: disposeBag)
        
        output.isActive
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.activeSwitch.isOn = value
            }).disposed(by: disposeBag)
    }
    
    func presentRegionView(){
        let vc = PlantRegionViewController()
        
        vc.modalPresentationStyle = .overFullScreen
        
        vc.selectRegion
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.selectRegion.accept(value)
            }).disposed(by: disposeBag)
        
        self.present(vc, animated: true)
    }
    
    func presentSearchView(){
        let vc = DictViewController(viewMode: .search)
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true)
    }
    
    func showWaterCycleAlert(){
        let vc = WaterCyclePickerViewController()
        
        vc.modalPresentationStyle = .overFullScreen
        
        vc.selectWaterCycle
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                owner.selectWaterCycle.accept(value)
            }).disposed(by: disposeBag)
        
        self.present(vc, animated: true)
    }
    
    @objc override func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(
                withDuration: 0
                , animations: { [self] in
                    tempViewConstraint?.update(offset:keyboardRectangle.height + 50)
                }
            )
        }
    }
    
    @objc override func keyboardDown() {
        self.view.transform = .identity
        tempViewConstraint?.update(offset: 30)
    }
}

extension InsertPlantViewController: CLLocationManagerDelegate{
    
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            self.locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            getLocationUsagePermission()
        case .denied:
            print("GPS 권한 요청 거부됨")
            getLocationUsagePermission()
        default:
            print("GPS: Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // the most recent location update is at the end of the array.
        let location: CLLocation = locations[locations.count - 1]
        //경도
        let longtitude: CLLocationDegrees = location.coordinate.longitude
        //위도
        let latitude:CLLocationDegrees = location.coordinate.latitude
        
        let findLocation = CLLocation(latitude: latitude, longitude: longtitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "ko_KR") //원하는 언어의 나라 코드를 넣어주시면 됩니다.
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                var setCity = String()
                var setRegion = String()
                if let region: String = address.last?.administrativeArea { setRegion = region } //시도
                if let city: String = address.last?.locality { setCity = city} //도시
                self.selectRegion.accept([setCity,setRegion])
            }
        })
    }
}
