//
//  DiaryCollectionViewCell.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/06.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class DiaryCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private lazy var backGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.shadowColor = CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 1
        return view
    }()
    
    private lazy var diaryImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 10
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private lazy var activityImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var conditionImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    func updateUI(isImg: Bool, activityImg: String, conditionImg: String, diaryId: Int, isUpdate: Bool) {
       
        if isImg {
            diaryImgView.loadDataImage(type: "diaries", id: diaryId, isUpdate: isUpdate)
        } else {
            diaryImgView.image = UIImage(named: getRandomSaessak())!.resizeImageTo(size: CGSize(width: 40, height: 45))
        }
        conditionImgView.image = UIImage(named: conditionImg)
        activityImgView.image = UIImage(named: activityImg)
    }
    
    func getRandomSaessak() -> String {
        let saessak = ["saesak_basics", "saesak_merong", "saesak_smile", "saesak_teeth", "saesak_wink"]
        return saessak.randomElement()!
    }
}

// MARK: - Private Functions

extension DiaryCollectionViewCell {
    private func configureUI() {
        
        contentView.addSubview(backGroundView)
        backGroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        backGroundView.addSubview(diaryImgView)
        diaryImgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(45)
            make.leading.equalToSuperview().offset(5)
        }

        backGroundView.addSubview(activityImgView)
        activityImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-5)
            make.width.height.equalTo(23)
        }
        
        backGroundView.addSubview(conditionImgView)
        conditionImgView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.width.height.equalTo(22)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}
