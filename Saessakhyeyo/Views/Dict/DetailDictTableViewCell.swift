//
//  DetailDictTableViewCell.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/04.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class DetailDictTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private lazy var dictTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var dictContentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
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
    
    func updateUI(title:String, content: String) {
        dictTitleLabel.text = title
        dictContentLabel.setAttributedText(content, fontSize: 13, kern: 0.5, lineSpacing: 3)
    }
}

// MARK: - Private Functions

extension DetailDictTableViewCell {
    private func configureUI() {
        
        self.selectionStyle = .none
        contentView.backgroundColor = .saessakLightGreen
        contentView.addSubview(dictTitleLabel)
        dictTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }

        contentView.addSubview(dictContentLabel)
        dictContentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalTo(dictTitleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}
