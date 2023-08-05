//
//  DiaryViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/25.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit
import AVFoundation
import Photos

class DiaryViewController: UIViewController {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    init(viewMode: ViewMode){
        self.viewMode = viewMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var backBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = .saessakDarkGreen
        return button
    }()
    
    private lazy var diaryImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 20
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    private lazy var myPlantImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 22.5
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    private lazy var myPlantNickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .saessakGray
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    private lazy var deleteBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "trashIcon")?.resizeImageTo(size: CGSize(width: 50, height: 40)), for: .normal)
        return button
    }()
    
    private var imgDeleteBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        button.setImage(UIImage(systemName: "xmark.circle", withConfiguration: config), for: .normal)
        button.tintColor = .saessakDarkGreen
        return button
    }()
    
    private var cameraBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cameraIcon")?.resizeImageTo(size: CGSize(width: 50, height: 40)), for: .normal)
        return button
    }()
    
    private var galleryBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "galleryIcon")?.resizeImageTo(size: CGSize(width: 45, height: 40)), for: .normal)
        return button
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
    
    private lazy var diaryLogoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "diaryLogo")
        return imgView
    }()
    
    private var weatherBtn: UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 11)
        button.setTitleColor(.saessakDarkGreen, for: .normal)
        return button
    }()
    
    private var condBtn: UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 11)
        button.setTitleColor(.saessakDarkGreen, for: .normal)
        return button
    }()
    
    private var activityBtn: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private var activityBtn2: UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 11)
        button.setTitleColor(.saessakDarkGreen, for: .normal)
        return button
    }()
    
    private var activityBtn3: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .darkGray
        textView.text = ""
        textView.becomeFirstResponder()
        return textView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var tempView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.text = "날씨 : "
        return label
    }()
    
    private lazy var condLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.text = "식물 상태 : "
        return label
    }()
    
    private lazy var activityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.text = "활동 : "
        return label
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        return imagePickerController
    }()
    
    private var diaryImgViewConstraint: Constraint?
    private var tempViewConstraint: Constraint?
    private var viewMode = ViewMode.create
    private let disposeBag = DisposeBag()
    private var diaryVM: DiaryViewModel?
    var selectWeather = PublishRelay<String>()
    var selectCond = PublishRelay<String>()
    var selectActivity = PublishRelay<[String]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
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


extension DiaryViewController {
    private func setView(){
        
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        imgDeleteBtn.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(10)
        }
        
        scrollView.addSubview(myPlantImgView)
        myPlantImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(backBtn.snp.centerY)
            make.width.height.equalTo(45)
            make.leading.equalTo(backBtn.snp.trailing).offset(15)
        }
        
        scrollView.addSubview(myPlantNickNameLabel)
        myPlantNickNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(myPlantImgView.snp.centerY)
            make.leading.equalTo(myPlantImgView.snp.trailing).offset(10)
        }
        
        scrollView.addSubview(diaryLogoImgView)
        diaryLogoImgView.snp.makeConstraints { make in
            make.centerY.equalTo(backBtn.snp.centerY)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(100)
            make.height.equalTo(45)
        }
        
        scrollView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(myPlantImgView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(15)
        }
        
        scrollView.addSubview(weatherLabel)
        weatherLabel.snp.makeConstraints { make in
            make.top.equalTo(myPlantImgView.snp.bottom).offset(20)
            make.leading.equalTo(dateLabel.snp.trailing).offset(20)
        }
        
        scrollView.addSubview(weatherBtn)
        weatherBtn.snp.makeConstraints { make in
            make.centerY.equalTo(weatherLabel.snp.centerY)
            make.leading.equalTo(weatherLabel.snp.trailing).offset(20)
            make.width.height.equalTo(35)
        }
        
        scrollView.addSubview(condLabel)
        condLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherBtn.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
        }
        
        scrollView.addSubview(condBtn)
        condBtn.snp.makeConstraints { make in
            make.centerY.equalTo(condLabel.snp.centerY)
            make.leading.equalTo(condLabel.snp.trailing).offset(20)
            make.width.height.equalTo(35)
        }
        
        scrollView.addSubview(activityLabel)
        activityLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherBtn.snp.bottom).offset(15)
            make.leading.equalTo(condBtn.snp.trailing).offset(20)
        }
        
        scrollView.addSubview(activityBtn)
        activityBtn.snp.makeConstraints { make in
            make.centerY.equalTo(activityLabel.snp.centerY)
            make.leading.equalTo(activityLabel.snp.trailing).offset(20)
            make.width.height.equalTo(35)
        }
        
        scrollView.addSubview(activityBtn2)
        activityBtn2.snp.makeConstraints { make in
            make.centerY.equalTo(activityLabel.snp.centerY)
            make.leading.equalTo(activityBtn.snp.trailing).offset(10)
            make.width.height.equalTo(35)
        }
        
        scrollView.addSubview(activityBtn3)
        activityBtn3.snp.makeConstraints { make in
            make.centerY.equalTo(activityLabel.snp.centerY)
            make.leading.equalTo(activityBtn2.snp.trailing).offset(10)
            make.width.height.equalTo(35)
        }
        
        scrollView.addSubview(topBarImgView)
        topBarImgView.snp.makeConstraints { make in
            make.top.equalTo(activityBtn3.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-20)
        }
        
        scrollView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(topBarImgView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(22)
        }
        
        scrollView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(view.snp.width).offset(-40)
            make.trailing.equalToSuperview().offset(-20)
        }

        scrollView.addSubview(diaryImgView)
        diaryImgView.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(25)
            diaryImgViewConstraint = make.height.equalTo(0).constraint
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        scrollView.addSubview(imgDeleteBtn)
        imgDeleteBtn.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(15)
            make.trailing.equalToSuperview().offset(-18)
        }
        
        scrollView.addSubview(bottomBarImgView)
        bottomBarImgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-40)
            make.width.equalToSuperview().offset(-20)
        }
        
        scrollView.addSubview(galleryBtn)
        galleryBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(bottomBarImgView.snp.top).offset(-10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        scrollView.addSubview(cameraBtn)
        cameraBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(bottomBarImgView.snp.top).offset(-10)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(bottomBarImgView.snp.top).offset(-10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        scrollView.addSubview(tempView)
        tempView.snp.makeConstraints { (make) in
            make.top.equalTo(diaryImgView.snp.bottom)
            tempViewConstraint = make.height.equalTo(40).constraint
            make.bottom.equalToSuperview().offset(-44)
        }
    }
    
    private func bindUI(){
        self.cameraBtn.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                AVCaptureDevice.authorized
                    .skip{ !$0 }
                    .take(1)
                    .asDriver(onErrorJustReturn: false)
                    .drive(with: self, onNext: { owner, value in
                        owner.imagePickerController.sourceType = .camera
                        owner.present(owner.imagePickerController, animated: true)}
                    ).disposed(by: owner.disposeBag)
            }).disposed(by: disposeBag)
        
        self.galleryBtn.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                DispatchQueue.main.async {
                    PHPhotoLibrary.authorized
                        .skip{ !$0 }
                        .take(1)
                        .asDriver(onErrorJustReturn: false)
                        .drive(with: self, onNext: { owner, value in
                            owner.imagePickerController.sourceType = .photoLibrary
                            owner.present(owner.imagePickerController, animated: true)}
                        ).disposed(by: owner.disposeBag)
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindVM(){
        self.diaryVM = DiaryViewModel()
        let input = DiaryViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in self.viewMode},
            viewWillDisappearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillDisappear)).map {[weak self] _ in self?.diaryImgView.image?.jpegData(compressionQuality: 0.2)},
            backBtnTap: self.backBtn.rx.tap.asObservable(),
            weatherBtnTap: self.weatherBtn.rx.tap.asObservable(),
            conditionBtnTap: self.condBtn.rx.tap.asObservable(),
            activityBtnTap: self.activityBtn.rx.tap.asObservable(),
            activityBtn2Tap: self.activityBtn2.rx.tap.asObservable(),
            activityBtn3Tap: self.activityBtn3.rx.tap.asObservable(),
            deleteBtnTap: self.deleteBtn.rx.tap.asObservable(),
            imgDeleteBtnTap: self.imgDeleteBtn.rx.tap.asObservable(),
            selectWeather: self.selectWeather.asObservable(),
            selectCond: self.selectCond.asObservable(),
            selectActivity: self.selectActivity.asObservable(),
            textViewEdit: self.textView.rx.text.orEmpty.asObservable())
        
        let output = self.diaryVM!.transform(from: input, disposeBag: self.disposeBag)
        
        output.didLoadPlantData
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.myPlantImgView.loadImage(value[1])
                owner.myPlantNickNameLabel.text = value[0]
            })
            .disposed(by: disposeBag)
        
        output.dateText
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.dateLabel.text = value
            })
            .disposed(by: disposeBag)
        
        output.diaryImgData
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                if value != -1 {
                    owner.diaryImgView.loadDataImage(type: "diaries", id: value, isUpdate: false)
                    owner.diaryImgViewConstraint?.update(offset: 200)
                    owner.imgDeleteBtn.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        output.weatherImg
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.weatherBtn.setImage(UIImage(named: value), for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.conditionImg
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.condBtn.setImage(UIImage(named: value), for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.activityImg
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.activityBtn2.setImage(UIImage(), for: .normal)
                owner.activityBtn2.setTitle("선택", for: .normal)
                
                if value.count > 0 && value[0] != "" {
                    owner.activityBtn2.setTitle("", for: .normal)
                    owner.activityBtn.setImage(UIImage(named: value[0]), for: .normal)
                } else {
                    owner.activityBtn.setImage(UIImage(), for: .normal)
                }
                if value.count > 1 {
                    owner.activityBtn2.setImage(UIImage(named: value[1]), for: .normal)
                }
                if value.count > 2 {
                    owner.activityBtn3.setImage(UIImage(named: value[2]), for: .normal)
                } else {
                    owner.activityBtn3.setImage(UIImage(), for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        output.textViewText
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.textView.text = value
                owner.textView.isScrollEnabled = false
                owner.textView.sizeToFit()
            })
            .disposed(by: disposeBag)
        
        output.timeText
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.timeLabel.text = value
            })
            .disposed(by: disposeBag)
        
        output.dismissView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.navigationController?.popViewController(animated: value)
            }).disposed(by: disposeBag)
        
        output.presentDiaryIconSelectView
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, value in
                owner.presentDiaryIconSelectView(type: value)
            }).disposed(by: disposeBag)
        
        output.deleteImgData
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                if value {
                    owner.diaryImgViewConstraint?.update(offset: 0)
                    owner.imgDeleteBtn.isHidden = true
                }
            }).disposed(by: disposeBag)
    }
    
    func presentDiaryIconSelectView(type: String) {
        
        let icon = ["weather" : ["sun", "wind", "rain", "cloud", "suncloud", "snow"], "condition" : ["condition_good", "condition_soso", "condition_weck", "condition_excited", "condition_bad"], "activity" : ["pruning", "wind", "sun", "water","energy","soil"]]
        
        let vc = SelectDiaryIconViewController(diaryIconList: icon[type]!, alertTitle: type == "activity" ? "활동을 선택해주세요 (최대 3개)" : type == "weather" ? "날씨를 선택해주세요" : "식물 상태를 선택해주세요")
        
        vc.modalPresentationStyle = .overFullScreen
        vc.selectValue
            .withUnretained(self)
            .subscribe(onNext: { owner, value in
                print(value)
                if type == "weather" {
                    owner.selectWeather.accept(value[0])
                } else if type == "condition" {
                    owner.selectCond.accept(value[0])
                } else {
                    owner.selectActivity.accept(value)
                }
            }).disposed(by: disposeBag)
        
        self.present(vc, animated: true)
    }
    
    private func automaticallySizeToFit(superFrame: CGSize) {
        let initalSize = CGSize(width: superFrame.width, height: 1000)
        let estimateSize = textView.sizeThatFits(initalSize)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimateSize.height
            }
        }
    }
}

extension DiaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let userPickedImage = info[.originalImage] as? UIImage else {
            fatalError("선택된 이미지를 불러오지 못했습니다 : userPickedImage의 값이 nil입니다. ")
        }
        diaryImgViewConstraint?.update(offset: 200)
        diaryImgView.image = userPickedImage
        imgDeleteBtn.isHidden = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension DiaryViewController {
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
        tempViewConstraint?.update(offset: 40)
    }
}
