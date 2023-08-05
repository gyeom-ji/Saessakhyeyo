//
//  CustomSliderView.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/05.
//

import Foundation
import SnapKit

final class CustomSliderView: UIView {
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var img = String()

    private lazy var sliderImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: img)
        imgView.tag = 1
        
        return imgView
    }()
    
    private lazy var sliderImgView2: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: img)
        imgView.tag = 2
        
        return imgView
    }()
    
    private lazy var sliderImgView3: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: img)
        imgView.tag = 3
        
        return imgView
    }()
    
    private lazy var sliderImgView4: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: img)
        imgView.tag = 4
        
        return imgView
    }()
    
    private lazy var sliderImgView5: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: img)
        imgView.tag = 5
        
        return imgView
    }()
    
    private lazy var lessLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .saessakGray
        label.text = "적음"
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var maxLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .saessakGray
        label.text = "많음"
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
}

extension CustomSliderView {
   private func configureUI() {
        self.backgroundColor = .clear
        
       self.addSubview(lessLabel)
       lessLabel.snp.makeConstraints { (make) in
           make.centerY.equalToSuperview()
           make.leading.equalToSuperview()
           make.width.equalTo(28)
           make.height.equalTo(30)
       }
       
       self.addSubview(sliderImgView)
       sliderImgView.snp.makeConstraints { (make) in
           make.centerY.equalToSuperview()
           make.leading.equalTo(lessLabel.snp.trailing).offset(10)
           make.width.equalTo(28)
           make.height.equalTo(30)
       }
       self.addSubview(sliderImgView2)
       sliderImgView2.snp.makeConstraints { (make) in
           make.centerY.equalToSuperview()
           make.leading.equalTo(sliderImgView.snp.trailing).offset(10)
           make.width.equalTo(28)
           make.height.equalTo(30)
       }
       self.addSubview(sliderImgView3)
       sliderImgView3.snp.makeConstraints { (make) in
           make.centerY.equalToSuperview()
           make.leading.equalTo(sliderImgView2.snp.trailing).offset(10)
           make.width.equalTo(28)
           make.height.equalTo(30)
       }
       self.addSubview(sliderImgView4)
       sliderImgView4.snp.makeConstraints { (make) in
           make.centerY.equalToSuperview()
           make.leading.equalTo(sliderImgView3.snp.trailing).offset(10)
           make.width.equalTo(28)
           make.height.equalTo(30)
       }
       self.addSubview(sliderImgView5)
       sliderImgView5.snp.makeConstraints { (make) in
           make.centerY.equalToSuperview()
           make.leading.equalTo(sliderImgView4.snp.trailing).offset(10)
           make.width.equalTo(28)
           make.height.equalTo(30)
       }

       self.addSubview(maxLabel)
       maxLabel.snp.makeConstraints { (make) in
           make.centerY.equalTo(sliderImgView5.snp.centerY)
           make.trailing.equalToSuperview()
           make.leading.equalTo(sliderImgView5.snp.trailing).offset(10)
       }
    }
}
