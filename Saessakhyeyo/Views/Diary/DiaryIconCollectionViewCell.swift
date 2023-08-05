//
//  DiaryIconCollectionViewCell.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/25.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class DiaryIconCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 10
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()

    private lazy var backGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 15
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
    }
    
    func updateUI(img: String) {
        imgView.image = UIImage(named: img)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backGroundView.backgroundColor = .saessakBeige
            } else {
                backGroundView.backgroundColor = .clear
            }
        }
    }
}

// MARK: - Private Functions

extension DiaryIconCollectionViewCell {
    private func configureUI() {

        contentView.addSubview(backGroundView)
        backGroundView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        backGroundView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.bottom.trailing.equalToSuperview().offset(-10)
        }
    }
}
