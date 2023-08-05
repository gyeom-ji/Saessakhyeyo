//
//  CalendarTableViewCell.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/30.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class CalendarTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    var editBtnTap = PublishRelay<Bool>()
    var deleteBtnTap = PublishRelay<Bool>()
    
     lazy var editBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)

        
        button.tintColor = UIColor.saessakDarkGreen

        return button
    }()
    
    private lazy var planImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var planLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .saessakDarkGreen
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var backGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 1
        return view
    }()
    
    func updateUI(plan:String, planImg: String) {
        planLabel.text = plan
        planImgView.image = UIImage(named: planImg)
    }
}

// MARK: - Private Functions

extension CalendarTableViewCell {
    private func configureUI() {
        
        self.selectionStyle = .none
        
        contentView.addSubview(backGroundView)
        backGroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        backGroundView.addSubview(planImgView)
        planImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(15)
            make.width.height.equalTo(40)
        }
        
        backGroundView.addSubview(planLabel)
        planLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(planImgView.snp.trailing).offset(5)
            make.width.equalTo(contentView.snp.width).offset(-150)
        }
        
        backGroundView.addSubview(editBtn)
        editBtn.snp.makeConstraints { make in
            make.trailing.equalTo(backGroundView.snp.trailing).offset(-5)
            make.top.equalTo(backGroundView.snp.top).offset(5)
            make.width.equalTo(44)
            make.height.equalTo(31)
        }
    }
}
