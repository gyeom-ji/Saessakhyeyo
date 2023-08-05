//
//  SelectMyPlantTableViewCell.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/29.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class SelectMyPlantTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private lazy var plantImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor.clear.cgColor
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 25
        return imgView
    }()
    
    private lazy var plantNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var plantDdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .saessakDarkGreen
        label.textAlignment = .left
        label.numberOfLines = 1
        
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
    
    func updateUI(plantName:String, plantImg: String, dday: String) {
        
        plantNameLabel.text = plantName
        
        if plantName == "전체" {
            plantImgView.image = UIImage(named: plantImg)!.resizeImageTo(size: CGSize(width: 45, height: 45))
        } else {
            plantImgView.loadImage(plantImg)
            plantDdayLabel.text = dday
        }
    }
}

// MARK: - Private Functions

extension SelectMyPlantTableViewCell {
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
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(50)
        }

        backGroundView.addSubview(plantNameLabel)
        plantNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(plantImgView.snp.trailing).offset(10)
            make.centerY.equalTo(plantImgView.snp.centerY)
        }
        
        backGroundView.addSubview(plantDdayLabel)
        plantDdayLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-25)
            make.centerY.equalTo(plantImgView.snp.centerY)
        }
    }
}
