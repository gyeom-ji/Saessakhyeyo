//
//  CommentTableViewCell.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/02.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class CommentStackItem: UIView {
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var editBtnTap = PublishRelay<Bool>()
    private var deleteBtnTap = PublishRelay<Bool>()
    
    var editComment: Observable<Bool> {
        return editBtnTap.asObservable()
    }
    var deleteComment: Observable<Bool> {
        return deleteBtnTap.asObservable()
    }
    
    var view: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var commentUserImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor.clear.cgColor
        imgView.clipsToBounds = true

        return imgView
    }()
    
    private lazy var commentContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private lazy var commentAnsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var commentDateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .right
        label.textColor = .gray
        
        return label
    }()
    
    private lazy var commentUserNicknameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.saessakDarkGreen
        return label
    }()
    
    private lazy var backGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var commentEditBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        var menuItems: [UIAction] {
            return [
                UIAction(title: "수정", image: UIImage(systemName: "pencil"), handler: { (_) in self.editBtnTap.accept(true)}),
                UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive,handler: { (_) in  self.deleteBtnTap.accept(true)}),
            ]
        }

        button.tintColor = UIColor.saessakDarkGreen
        button.menu = UIMenu(image: nil, identifier: nil, options: [], children: menuItems)
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    func updateUI(mode: Int, userNickname: String, content: [String], dateTime: String, isShowEditBtn: Bool) {
        
        /// 공통 적용
        self.commentUserNicknameLabel.text = userNickname
        self.commentContentLabel.text = content[0]
        self.commentDateTimeLabel.text = dateTime
        self.commentDateTimeLabel.sizeToFit()
        self.commentEditBtn.isHidden = !isShowEditBtn
        
        switch mode {
        case 0:
            self.commentUserImgView.image = UIImage(named: "saesak_basics")
            self.commentAnsLabel.text = content[2]
            self.commentAnsLabel.sizeThatFits( CGSize(width: 320, height: CGFloat.greatestFiniteMagnitude))

        case 1:
            self.commentUserImgView.image = UIImage(named: "saesak_basics")
            self.commentContentLabel.textAlignment = .center
            
        case 2:
            self.commentUserImgView.image = UIImage(named: "user")
           
        default:
            print("error mode")
        }
    }
}

// MARK: - Private Functions

extension CommentStackItem {
   private func configureUI() {
        self.backgroundColor = .saessakLightGreen
        
        self.addSubview(self.backGroundView)
        self.backGroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        }

        self.addSubview(self.commentUserImgView)
        self.commentUserImgView.snp.makeConstraints { make in
            make.leading.equalTo(self.backGroundView.snp.leading).offset(10)
            make.top.equalTo(self.backGroundView.snp.top).offset(10)
            make.width.height.equalTo(40)
        }
        
        self.addSubview(self.commentUserNicknameLabel)
        self.commentUserNicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.commentUserImgView.snp.trailing).offset(10)
            make.height.equalTo(20)
            make.centerY.equalTo(commentUserImgView.snp.centerY)
        }
        
        self.addSubview(self.commentEditBtn)
        self.commentEditBtn.snp.makeConstraints { make in
            make.trailing.equalTo(self.backGroundView.snp.trailing).offset(-5)
            make.top.equalTo(self.backGroundView.snp.top).offset(5)
            make.width.equalTo(44)
            make.height.equalTo(31)
        }

        self.addSubview(self.commentContentLabel)
        self.commentContentLabel.snp.makeConstraints { make in
            make.top.equalTo(self.commentUserImgView.snp.bottom).offset(10)
            make.leading.equalTo(self.backGroundView.snp.leading).offset(10)
            make.trailing.equalTo(self.backGroundView.snp.trailing).offset(-10)
        }
    
        self.addSubview(self.commentAnsLabel)
        self.commentAnsLabel.snp.makeConstraints { make in
            make.top.equalTo(self.commentContentLabel.snp.bottom).offset(10)
            make.leading.equalTo(self.backGroundView.snp.leading).offset(5)
            make.trailing.equalTo(self.backGroundView.snp.trailing).offset(-5)
        }
        
        self.addSubview(self.commentDateTimeLabel)
        self.commentDateTimeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.backGroundView.snp.trailing).offset(-13)
            make.top.equalTo(self.commentContentLabel.snp.bottom).offset(10)
            make.bottom.equalTo(self.backGroundView.snp.bottom).offset(-10)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
    }
}
