//
//  CustomAlertView.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/07.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class CustomAlertView: UIView {
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.configureUI()
        self.bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let disposeBag = DisposeBag()
    var saveBtnTap = PublishRelay<Bool>()
    var cancelBtnTap = PublishRelay<Bool>()
    
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.saessakBeige.cgColor
        view.layer.borderWidth = 3
        return view
    }()
    
    private lazy var alertLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.textAlignment = .center

        return label
    }()
    
    private lazy var alertContentView = UIView()
    
    private lazy var saveBtn: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = .saessakDarkGreen
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.saessakDarkGreen, for: .normal)
        button.backgroundColor = .saessakBeige
       
        return button
    }()
    
    private lazy var cancelBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        button.tintColor = .saessakDarkGreen

        return button
    }()
    
    func updateUI(alertText:String, content: UIView) {
        alertLabel.text = alertText
        
        alertContentView.addSubview(content)
        content.snp.makeConstraints { (make) in
            make.top.bottom.trailing.leading.equalToSuperview()
        }
    }
}

// MARK: - Private Functions

extension CustomAlertView {
   private func configureUI() {

       self.backgroundColor = .white
       self.layer.cornerRadius = 20
       self.layer.borderColor = UIColor.saessakBeige.cgColor
       self.layer.borderWidth = 3
       
       self.addSubview(cancelBtn)
       cancelBtn.snp.makeConstraints { (make) in
           make.trailing.equalToSuperview().offset(-15)
           make.top.equalToSuperview().offset(15)
       }
       
       self.addSubview(alertLabel)
       alertLabel.snp.makeConstraints { (make) in
           make.trailing.leading.equalToSuperview()
           make.top.equalTo(cancelBtn.snp.bottom).offset(10)
       }
       
       self.addSubview(alertContentView)
       alertContentView.snp.makeConstraints { (make) in
           make.trailing.equalToSuperview().offset(-20)
           make.leading.equalToSuperview().offset(20)
           make.top.equalTo(alertLabel.snp.bottom).offset(20)
       }
       
       self.addSubview(saveBtn)
       saveBtn.snp.makeConstraints { (make) in
           make.centerX.equalToSuperview()
           make.bottom.equalToSuperview().offset(-20)
           make.top.equalTo(alertContentView.snp.bottom).offset(20)
           make.width.equalTo(60)
           make.height.equalTo(40)
       }
    }
    
    private func bindUI(){
        saveBtn.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.saveBtnTap.accept(true)
            }).disposed(by: disposeBag)
        
        cancelBtn.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.cancelBtnTap.accept(true)
            }).disposed(by: disposeBag)
    }
}
