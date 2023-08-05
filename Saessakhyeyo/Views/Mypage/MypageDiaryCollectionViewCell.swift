//
//  MypageDiaryCollectionViewCell.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/29.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class MypageDiaryCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
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
    
    func updateUI(isImg: Bool, diaryId: Int, isUpdate: Bool) {
         if isImg {
             imgView.loadDataImage(type: "diaries", id: diaryId, isUpdate: isUpdate)
         } else {
             imgView.image = UIImage(named: getRandomSaessak())
         }
    }
    
    func getRandomSaessak() -> String {
        let saessak = ["saesak_basics", "saesak_merong", "saesak_smile", "saesak_teeth", "saesak_wink"]
        return saessak.randomElement()!
    }
}

// MARK: - Private Functions

extension MypageDiaryCollectionViewCell {
    private func configureUI() {

        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }
}
