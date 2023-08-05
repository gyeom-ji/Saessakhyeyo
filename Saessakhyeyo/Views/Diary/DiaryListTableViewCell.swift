//
//  DiaryListTableViewCell.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/25.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class DiaryListTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private lazy var diaryImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 10
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private lazy var weatherImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var condImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var activityImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var activityImgView2: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var activityImgView3: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .lightGray
        label.textAlignment = .right
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
    
    func updateUI(isImg: Bool, cond: String, act1: String, act2: String, act3: String, weather: String, date: String, content: String, diaryId: Int, isUpdate: Bool) {

        if isImg {
            diaryImgView.loadDataImage(type: "diaries", id: diaryId, isUpdate: isUpdate)
        } else {
            diaryImgView.image = UIImage(named: getRandomSaessak())!.resizeImageTo(size: CGSize(width: 45, height: 50))
        }
        weatherImgView.image = UIImage(named: weather)
        condImgView.image = UIImage(named: cond)
        activityImgView.image = UIImage(named: act1)
        activityImgView2.image = UIImage(named: act2)
        activityImgView3.image = UIImage(named: act3)
        
        contentLabel.text = content
        dateLabel.text = date
    }
    
    func getRandomSaessak() -> String {
        let saessak = ["saesak_basics", "saesak_merong", "saesak_smile", "saesak_teeth", "saesak_wink"]
        return saessak.randomElement()!
    }
}

// MARK: - Private Functions

extension DiaryListTableViewCell {
    private func configureUI() {
        
        self.selectionStyle = .none
        
        contentView.addSubview(backGroundView)
        backGroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        backGroundView.addSubview(diaryImgView)
        diaryImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
            make.height.width.equalTo(50)
        }

        backGroundView.addSubview(weatherImgView)
        weatherImgView.snp.makeConstraints { make in
            make.top.equalTo(diaryImgView.snp.top)
            make.leading.equalTo(diaryImgView.snp.trailing).offset(10)
            make.height.width.equalTo(18)
        }
        
        backGroundView.addSubview(condImgView)
        condImgView.snp.makeConstraints { make in
            make.top.equalTo(diaryImgView.snp.top)
            make.leading.equalTo(weatherImgView.snp.trailing).offset(10)
            make.height.width.equalTo(18)
        }
        
        backGroundView.addSubview(activityImgView)
        activityImgView.snp.makeConstraints { make in
            make.top.equalTo(diaryImgView.snp.top)
            make.leading.equalTo(condImgView.snp.trailing).offset(10)
            make.height.width.equalTo(18)
        }
        
        backGroundView.addSubview(activityImgView2)
        activityImgView2.snp.makeConstraints { make in
            make.top.equalTo(diaryImgView.snp.top)
            make.leading.equalTo(activityImgView.snp.trailing).offset(10)
            make.height.width.equalTo(18)
        }
        
        backGroundView.addSubview(activityImgView3)
        activityImgView3.snp.makeConstraints { make in
            make.top.equalTo(diaryImgView.snp.top)
            make.leading.equalTo(activityImgView2.snp.trailing).offset(10)
            make.height.width.equalTo(18)
        }
        
        backGroundView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(activityImgView3.snp.bottom).offset(5)
            make.leading.equalTo(diaryImgView.snp.trailing).offset(10)
            make.width.equalTo(contentView.snp.width).offset(-130)
            make.height.equalTo(20)
        }

        backGroundView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(20)
        }
    }
}
