//
//  MyPlantTableViewCell.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/07.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class MyPlantTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private lazy var plantImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor.clear.cgColor
        imgView.layer.cornerRadius = 50
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        
        return imgView
    }()
    
    private lazy var sunImageView = MyPlantConditionImageView()
    
    private lazy var windImageView = MyPlantConditionImageView()
    
    private lazy var waterImageView = MyPlantConditionImageView()
    
    private lazy var plantNickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.textAlignment = .center
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    func updateUI(sunCondition: Int, windCondition: Int, waterCondition: Int, plantNickName: String, dday: String, plantImg: String) {
        
        self.plantNickNameLabel.text = plantNickName
        self.dDayLabel.text = dday
        
        self.plantImgView.loadImage(plantImg)
        
        self.sunImageView.updateUI(condition: sunCondition, imgName: "sun.min.fill", color: .sunRed)
        self.windImageView.updateUI(condition: windCondition, imgName: "wind", color: .windFullBlue)
        self.waterImageView.updateUI(condition: waterCondition, imgName: "drop.fill", color: .waterBlue)
    }
}

// MARK: - Private Functions

extension MyPlantTableViewCell {
    private func configureUI() {
        
        self.selectionStyle = .none
        
        contentView.addSubview(backGroundView)
        backGroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        backGroundView.addSubview(plantImgView)
        plantImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        backGroundView.addSubview(windImageView)
        windImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        
        backGroundView.addSubview(sunImageView)
        sunImageView.snp.makeConstraints { make in
            make.bottom.equalTo(windImageView.snp.top).offset(-10)
            make.leading.equalToSuperview().offset(10)
        }

        backGroundView.addSubview(waterImageView)
        waterImageView.snp.makeConstraints { make in
            make.top.equalTo(windImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        backGroundView.addSubview(plantNickNameLabel)
        plantNickNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalTo(plantImgView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        backGroundView.addSubview(dDayLabel)
        dDayLabel.snp.makeConstraints { make in
            make.top.equalTo(plantNickNameLabel.snp.bottom).offset(15)
            make.leading.equalTo(plantImgView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}
