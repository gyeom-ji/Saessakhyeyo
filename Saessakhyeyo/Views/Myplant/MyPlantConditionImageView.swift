//
//  MyPlantConditionImageView.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/07.
//

import Foundation
import SnapKit

final class MyPlantConditionImageView: UIView {
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var conditionImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.tag = 1
        
        return imgView
    }()
    
    private lazy var conditionImgView2: UIImageView = {
        let imgView = UIImageView()
        imgView.tag = 2
        
        return imgView
    }()
    
    private lazy var conditionImgView3: UIImageView = {
        let imgView = UIImageView()
        imgView.tag = 3
        
        return imgView
    }()
    
    private lazy var conditionImgView4: UIImageView = {
        let imgView = UIImageView()
        imgView.tag = 4
        
        return imgView
    }()
    
    private lazy var conditionImgView5: UIImageView = {
        let imgView = UIImageView()
        imgView.tag = 5
        
        return imgView
    }()
    
    func updateUI(condition: Int, imgName: String, color: UIColor){
        for i in 1...condition{
            if let image = self.viewWithTag(i) as? UIImageView {
                image.tintColor = color
                image.image = UIImage(systemName: imgName)
            }
        }
    }
}

extension MyPlantConditionImageView {
   private func configureUI() {
        self.backgroundColor = .clear
       
       self.addSubview(conditionImgView)
       conditionImgView.snp.makeConstraints { (make) in
           make.top.bottom.equalToSuperview()
           make.leading.equalToSuperview()
           make.width.equalTo(15)
           make.height.equalTo(17)
       }
       self.addSubview(conditionImgView2)
       conditionImgView2.snp.makeConstraints { (make) in
           make.top.bottom.equalToSuperview()
           make.leading.equalTo(conditionImgView.snp.trailing).offset(8)
           make.width.equalTo(15)
           make.height.equalTo(17)
       }
       self.addSubview(conditionImgView3)
       conditionImgView3.snp.makeConstraints { (make) in
           make.top.bottom.equalToSuperview()
           make.leading.equalTo(conditionImgView2.snp.trailing).offset(8)
           make.width.equalTo(15)
           make.height.equalTo(17)
       }
       self.addSubview(conditionImgView4)
       conditionImgView4.snp.makeConstraints { (make) in
           make.top.bottom.equalToSuperview()
           make.leading.equalTo(conditionImgView3.snp.trailing).offset(8)
           make.width.equalTo(15)
           make.height.equalTo(17)
       }
       self.addSubview(conditionImgView5)
       conditionImgView5.snp.makeConstraints { (make) in
           make.top.bottom.equalToSuperview()
           make.leading.equalTo(conditionImgView4.snp.trailing).offset(10)
           make.width.equalTo(15)
           make.height.equalTo(17)
           make.trailing.equalToSuperview()
       }
    }
}
