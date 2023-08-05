//
//  InsertQuestionView.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/02.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Photos

class InsertQuestionViewController: UIViewController {
    
    init(viewMode: ViewMode){
        self.viewMode = viewMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var questionImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 20
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .darkGray
        textView.text = ""
        textView.becomeFirstResponder()
        return textView
    }()
    
    private lazy var categoryBtn: UIButton = {
        let button = UIButton()
        button.setTitle("전체  ", for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.setTitleColor(.saessakDarkGreen, for: .normal)
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.down", withConfiguration: config), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        
        var menuItems: [UIAction] {
            return [
                UIAction(title: "전체", handler: { (_) in self.categoryBtn.setTitle("전체  ", for: .normal); }),
                UIAction(title: "식물관리", handler: { (_) in self.categoryBtn.setTitle("식물관리  ", for: .normal);}),
                UIAction(title: "아파요", handler: { (_) in self.categoryBtn.setTitle("아파요  ", for: .normal);}),
                UIAction(title: "식물종찾기", handler: { (_) in self.categoryBtn.setTitle("식물종찾기  ", for: .normal);}),
                UIAction(title: "꿀팁공유", handler: { (_) in self.categoryBtn.setTitle("꿀팁공유  ", for: .normal);}),
                
            ]
        }
        button.tintColor = UIColor.saessakDarkGreen
        button.menu = UIMenu(image: nil, identifier: nil, options: [], children: menuItems)
        button.showsMenuAsPrimaryAction = true
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
    
    private lazy var backBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.backward", withConfiguration: config), for: .normal)
        button.tintColor = .saessakDarkGreen
        return button
    }()
    
    private lazy var insertBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pencilIcon")?.resizeImageTo(size: CGSize(width: 50, height: 50)), for: .normal)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .saessakBeige
        return view
    }()
    
    private lazy var tempView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        return imagePickerController
    }()
    
    private var questionImgViewConstraint: Constraint?
    private var tempViewConstraint: Constraint?
    private var viewMode = ViewMode.create
    private let disposeBag = DisposeBag()
    var questionVM: InsertQuestionViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        bindGesture(disposeBag: disposeBag)
        setView()
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

extension InsertQuestionViewController {
    
    private func setView(){
        
        hideKeyboardWhenTappedAround()
        imgDeleteBtn.isHidden = true
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.leading.equalToSuperview()
        }
        
        headerView.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(60)
            make.leading.equalToSuperview().offset(10)
        }
        
        headerView.addSubview(categoryBtn)
        categoryBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(backBtn.snp.trailing).offset(20)
            make.centerY.equalTo(backBtn.snp.centerY)
        }
        
        headerView.addSubview(insertBtn)
        insertBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(backBtn.snp.centerY)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(headerView.snp.bottom)
        }
        
        scrollView.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(view.snp.width).offset(-40)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        scrollView.addSubview(questionImgView)
        questionImgView.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(25)
            questionImgViewConstraint = make.height.equalTo(0).constraint
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        scrollView.addSubview(imgDeleteBtn)
        imgDeleteBtn.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(15)
            make.trailing.equalToSuperview().offset(-18)
        }
        
        scrollView.addSubview(galleryBtn)
        galleryBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-30)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        scrollView.addSubview(cameraBtn)
        cameraBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-30)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        scrollView.addSubview(tempView)
        tempView.snp.makeConstraints { (make) in
            make.top.equalTo(questionImgView.snp.bottom)
            tempViewConstraint = make.height.equalTo(30).constraint
            make.bottom.equalToSuperview().offset(-34)
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
        self.questionVM = InsertQuestionViewModel()
        
        let input = InsertQuestionViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in self.viewMode},
            textViewEdit: self.textView.rx.text.orEmpty.asObservable(),
            categoryBtnTap: self.categoryBtn.rx.tap.asObservable().map { [weak self] in self!.categoryBtn.titleLabel!.text! },
            backBtnTap: self.backBtn.rx.tap.asObservable(),
            insertBtnTap: self.insertBtn.rx.tap.asObservable().map { [weak self] in self?.questionImgView.image?.jpegData(compressionQuality: 0.2)},
            imgDeleteBtnTap: self.imgDeleteBtn.rx.tap.asObservable()
        )
        
        let output = self.questionVM!.transform(from: input, disposeBag: self.disposeBag)
        
        output.dismissView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.navigationController?.popViewController(animated: value)
            }).disposed(by: disposeBag)
        
        output.textViewText
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.textView.text = value
                owner.textView.isScrollEnabled = false
                owner.textView.sizeToFit()
            })
            .disposed(by: disposeBag)
        
        output.categoryTitle
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.categoryBtn.setTitle("전체", for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.imgData
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                if value != -1 {
                    owner.imgDeleteBtn.isHidden = false
                    owner.questionImgView.loadDataImage(type: "questions", id: value, isUpdate: false)
                    owner.questionImgViewConstraint?.update(offset: 200)
                }
            }).disposed(by: disposeBag)
        
        output.deleteImgData
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                if value {
                    owner.questionImgViewConstraint?.update(offset: 0)
                    owner.imgDeleteBtn.isHidden = true
                }
            }).disposed(by: disposeBag)
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

extension InsertQuestionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let userPickedImage = info[.originalImage] as? UIImage else {
            fatalError("선택된 이미지를 불러오지 못했습니다 : userPickedImage의 값이 nil입니다. ")
        }
        questionImgViewConstraint?.update(offset: 200)
        questionImgView.image = userPickedImage
        imgDeleteBtn.isHidden = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension InsertQuestionViewController {
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
