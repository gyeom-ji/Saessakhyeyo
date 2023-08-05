//
//  QuestionTableViewCell.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/04.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class QuestionTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private lazy var questionImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 10
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    private lazy var questionContentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var commentCountImgView: UIImageView = {
        let imgView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
        imgView.image = UIImage(systemName: "text.bubble.fill", withConfiguration: config)
        imgView.tintColor = .saessakDarkGreen
        
        return imgView
    }()
    
    private lazy var commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .saessakDarkGreen
        
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
    
    func updateUI(isImg:Bool, content: String, commentCount: String, questionId: Int, isUpdate: Bool) {

        questionContentLabel.setAttributedText(content, fontSize: 13, kern: 0.5, lineSpacing: 5)
        commentCountLabel.text = commentCount
        if isImg {
            questionImgView.loadDataImage(type: "questions", id: questionId, isUpdate: isUpdate)
        } else {
            questionImgView.image = UIImage(named: getRandomSaessak())!.resizeImageTo(size: CGSize(width: 40, height: 45))
        }
    }
    
    func getRandomSaessak() -> String {
        let saessak = ["saesak_basics", "saesak_merong", "saesak_smile", "saesak_teeth", "saesak_wink"]
        return saessak.randomElement()!
    }
}

// MARK: - Private Functions

extension QuestionTableViewCell {
    private func configureUI() {
        
        self.selectionStyle = .none
        
        contentView.addSubview(backGroundView)
        backGroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        backGroundView.addSubview(questionImgView)
        questionImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
        
        backGroundView.addSubview(questionContentLabel)
        questionContentLabel.snp.makeConstraints { make in
            make.leading.equalTo(questionImgView.snp.trailing).offset(10)
            make.width.equalTo(contentView.snp.width).offset(-150)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        backGroundView.addSubview(commentCountImgView)
        commentCountImgView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        backGroundView.addSubview(commentCountLabel)
        commentCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(commentCountImgView.snp.trailing).offset(2)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
