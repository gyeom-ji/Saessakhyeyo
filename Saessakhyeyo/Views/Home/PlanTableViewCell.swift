//
//  PlanTableViewCell.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/06.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class PlanTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private lazy var checkBoxImgView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    private lazy var planLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .left
        
        return label
    }()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    func updateUI(plan:String, isCheck: Bool) {
        planLabel.text = plan
        checkBoxImgView.image = UIImage(named: isCheck ? "checkbox_fill" : "checkbox")
    }
}

// MARK: - Private Functions

extension PlanTableViewCell {
    private func configureUI() {
        
        self.selectionStyle = .none
        
        contentView.addSubview(checkBoxImgView)
        checkBoxImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(25)
            make.width.equalTo(20)
        }

        contentView.addSubview(planLabel)
        planLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkBoxImgView.snp.centerY).offset(2)
            make.leading.equalTo(checkBoxImgView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
}
