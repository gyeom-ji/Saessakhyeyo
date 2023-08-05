//
//  WateringTableViewCell.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/07.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class WateringTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private lazy var plantImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor.clear.cgColor
        imgView.layer.cornerRadius = 25
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        
        return imgView
    }()
    
    private lazy var plantNickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var checkBoxBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkbox"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
        self.bindUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
        self.bindUI()
    }
    
    var selectBtn = PublishSubject<Bool>()
    var value = false
    let disposeBag = DisposeBag()
    
    func updateUI(plantNickName: String, plantImg: String) {
        
        self.plantNickNameLabel.text = plantNickName
        self.plantImgView.loadImage(plantImg)
    }
}

// MARK: - Private Functions

extension WateringTableViewCell {
    private func configureUI() {
        
        self.selectionStyle = .none
        
        contentView.addSubview(checkBoxBtn)
        checkBoxBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(25)
            make.width.equalTo(20)
        }
        
        contentView.addSubview(plantImgView)
        plantImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalTo(checkBoxBtn.snp.trailing).offset(15)
            make.width.height.equalTo(50)
        }
        
        contentView.addSubview(plantNickNameLabel)
        plantNickNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(plantImgView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    private func bindUI(){
        self.checkBoxBtn.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.checkBoxBtn.setImage(UIImage(named: owner.value == true ? "checkbox" : "checkbox_fill"), for: .normal)
                owner.selectBtn.onNext(!owner.value)
                owner.value = !owner.value
            }).disposed(by: disposeBag)
    }
}
