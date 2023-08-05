//
//  ReadQuestionViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/02.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

class ReadQuestionViewController: UIViewController {

    private var commentViewConstraint: Constraint?
    private var questionImgViewConstraint: Constraint?
    
    private var questionImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 20
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        
        return imgView
    }()
    
    private var commentInsertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.saessakDarkGreen.cgColor
        return view
    }()
    
    private lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 13)
        textView.textColor = .darkGray
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.saessakDarkGreen.cgColor
        return textView
    }()
    
    private var commentCancelBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.tintColor = UIColor.darkGray
        return button
    }()
    
    private lazy var commentSaveBtn: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = UIColor.saessakLightGreen
        
        return button
    }()
    
    private lazy var commentInsertBtn: UIButton = {
        let button = UIButton()
        button.setTitle("         댓글 달기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.setTitleColor(.darkGray, for: .normal)
        button.setImage(UIImage(named: "pencilIcon")?.resizeImageTo(size: CGSize(width: 40, height: 40)), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.backgroundColor = UIColor.white
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 6
        button.layer.shadowColor = CGColor(red: 198/255, green: 198/255, blue: 200/255, alpha: 1)
        button.layer.cornerRadius = 15
        return button
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var tempView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .saessakLightGreen
        return scrollView
    }()
    
    private lazy var commentCountImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "text.bubble.fill")
        imgView.tintColor = .saessakDarkGreen
        
        return imgView
    }()
    
    private lazy var commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .saessakDarkGreen
        
        return label
    }()
    
    private lazy var dateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .right
        label.textColor = .gray
        
        return label
    }()
    
    private lazy var contentTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private lazy var editBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        var menuItems: [UIAction] {
            return [
                UIAction(title: "수정", image: UIImage(systemName: "pencil"), handler: { (_) in self.questionEditBtnTap.accept(true)}),
                UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive,handler: { (_) in  self.questionDeleteBtnTap.accept(true)}),
            ]
        }
        
        button.tintColor = UIColor.saessakGreen
        button.menu = UIMenu(image: nil, identifier: nil, options: [], children: menuItems)
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private lazy var userImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor.clear.cgColor
        imgView.clipsToBounds = true
        
        return imgView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .saessakDarkGreen
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var backBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.forward", withConfiguration: config), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .saessakDarkGreen
        return button
    }()
    
    private var commentEditBtnTap = PublishSubject<Comment>()
    private var commentDeleteBtnTap = PublishSubject<Int>()
    private var questionEditBtnTap = PublishRelay<Bool>()
    private var questionDeleteBtnTap = PublishRelay<Bool>()
    
    private let disposeBag = DisposeBag()
    private var questionVM : ReadQuestionViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        bindGesture(disposeBag: disposeBag)
        bindVM()
    }
}

extension ReadQuestionViewController {
    
    private func setView(){
        
        hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(commentInsertBtn)
        
        commentInsertBtn.snp.makeConstraints { (make) in
            make.width.equalTo(150)
            make.height.equalTo(35)
            make.bottom.equalTo(view.snp.bottom).offset(-50)
            make.centerX.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        contentView.addSubview(backBtn)
        backBtn.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(10)
        }
        
        contentView.addSubview(userImgView)
        userImgView.image = UIImage(named: "user")
        userImgView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.equalToSuperview()
            make.leading.equalTo(backBtn.snp.trailing).offset(10)
        }
        
        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(userImgView.snp.top).offset(5)
            make.leading.equalTo(userImgView.snp.trailing).offset(10)
        }
        
        contentView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(5)
            make.leading.equalTo(userImgView.snp.trailing).offset(10)
        }
        
        contentView.addSubview(editBtn)
        editBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview()
        }
        
        contentView.addSubview(contentTextLabel)
        contentTextLabel.snp.makeConstraints { make in
            make.top.equalTo(userImgView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(questionImgView)
        questionImgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentTextLabel.snp.bottom).offset(30)
            questionImgViewConstraint = make.height.equalTo(0).constraint
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(commentCountImgView)
        commentCountImgView.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(questionImgView.snp.bottom).offset(30)
        }
        
        contentView.addSubview(commentCountLabel)
        commentCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(commentCountImgView.snp.trailing).offset(12)
            make.centerY.equalTo(commentCountImgView.snp.centerY)
        }
        
        contentView.addSubview(dateTimeLabel)
        dateTimeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(commentCountImgView.snp.centerY)
        }
        
        setTableStack()
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(dateTimeLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(tempView)
        tempView.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom)
            commentViewConstraint = make.height.equalTo(0).constraint
            make.bottom.equalToSuperview()
        }
        
        scrollView.bringSubviewToFront(self.commentInsertBtn)
        
        /// commentInsertView
        contentView.addSubview(self.commentInsertView)
        commentInsertView.isHidden = true
        commentInsertView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        commentInsertView.addSubview(commentCancelBtn)
        commentCancelBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
        }
        
        commentInsertView.addSubview(commentTextView)
        commentTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(80)
            make.top.equalTo(commentCancelBtn.snp.bottom).offset(10)
        }
        
        commentInsertView.addSubview(commentSaveBtn)
        commentSaveBtn.snp.makeConstraints { make in
            make.leading.equalTo(commentTextView.snp.trailing)
            make.width.equalTo(50)
            make.height.equalTo(80)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(commentCancelBtn.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func setTableStack(){
        self.stackView.subviews.forEach( {$0.removeFromSuperview()})
        if self.questionVM?.commentList != nil {
            for i in 0..<(self.questionVM?.commentList.count)! {
                let cell = CommentStackItem()
                let comment = self.questionVM?.commentList[i]
                
                cell.updateUI(mode: 2, userNickname: comment!.userName, content: [comment!.content], dateTime: comment!.dateTime, isShowEditBtn: comment!.userId == self.questionVM!.userId)
                
                cell.editComment
                    .asDriver(onErrorJustReturn: false)
                    .drive(with: self, onNext: { owner, _ in
                        owner.commentEditBtnTap.onNext(comment!)
                    }).disposed(by: disposeBag)
                
                cell.deleteComment
                    .asDriver(onErrorJustReturn: false)
                    .drive(with: self, onNext: { owner, _ in
                        owner.commentDeleteBtnTap.onNext(comment!.id)
                    }).disposed(by: disposeBag)
                cell.tag = i
                self.stackView.addArrangedSubview(cell)
            }
        }
    }
    
    private func bindVM(){
        self.questionVM = ReadQuestionViewModel()
        
        let input = ReadQuestionViewModel.Input(
            backBtnTap: self.backBtn.rx.tap.asObservable(),
            editBtnTap: questionEditBtnTap.asObservable(),
            deleteBtnTap: questionDeleteBtnTap.asObservable(), commentEditBtnTap: commentEditBtnTap.asObservable(), commentDeleteBtnTap: commentDeleteBtnTap.asObservable(),
            commentInsertBtnTap: self.commentInsertBtn.rx.tap.asObservable(),
            commentCancelBtnTap: self.commentCancelBtn.rx.tap.asObservable(),
            commentSaveBtnTap: self.commentSaveBtn.rx.tap.asObservable().map { [weak self] in self!.commentTextView.text})
        
        let output = self.questionVM!.transform(from: input, disposeBag: self.disposeBag)
        
        output.hideKeyboard
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.dismissKeyboard()
            }).disposed(by: disposeBag)
        
        output.isHiddenEditBtn
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.editBtn.isHidden = value
            }).disposed(by: disposeBag)
        
        output.dismissView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        output.presentUpdateView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                let vc = InsertQuestionViewController(viewMode: .update)
                owner.navigationController?.pushViewController(vc, animated: true)

            }).disposed(by: disposeBag)
        
        output.showInsertCommentView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.showInsertCommentView(isHidden: value, text: "")
            })
            .disposed(by: disposeBag)
        
        output.showEditCommentView
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, value in
                owner.showInsertCommentView(isHidden: false, text: value)
            })
            .disposed(by: disposeBag)
        
        output.showInsertCommentView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.showInsertCommentView(isHidden: value, text: "")
            })
            .disposed(by: disposeBag)
        
        output.questionContent
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.contentTextLabel.setAttributedText(value, fontSize: 15, kern: 0.5, lineSpacing: 5)
                owner.contentTextLabel.sizeToFit()
            })
            .disposed(by: disposeBag)
        
        output.userName
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.userNameLabel.text = value
                owner.userNameLabel.sizeToFit()
            })
            .disposed(by: disposeBag)
        
        output.category
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.categoryLabel.text = value
                owner.categoryLabel.sizeToFit()
            })
            .disposed(by: disposeBag)
        
        output.dateTime
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.dateTimeLabel.text = value
                owner.dateTimeLabel.sizeToFit()
            })
            .disposed(by: disposeBag)
        
        output.commentCnt
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.commentCountLabel.text = value
                owner.commentCountLabel.sizeToFit()
            })
            .disposed(by: disposeBag)
        
        output.imgData
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                if value != -1 {
                    owner.questionImgView.loadDataImage(type: "questions", id: value, isUpdate: true)
                    owner.questionImgViewConstraint?.update(offset: 200)
                } else {
                    owner.questionImgViewConstraint?.update(offset: 0)
                }
            }).disposed(by: disposeBag)
        
        output.didLoadCommentData
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.setTableStack()
            }).disposed(by: disposeBag)
    }
    
    func showInsertCommentView(isHidden: Bool, text: String){
        self.commentInsertView.isHidden = isHidden
        
        if !isHidden {
            commentInsertView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
            }
            self.commentTextView.text = text
            self.commentTextView.becomeFirstResponder()
        }
    }
}
 
extension ReadQuestionViewController {
    @objc override func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(
                withDuration: 0
                , animations: { [self] in
                    
                    commentViewConstraint?.update(offset:keyboardRectangle.height + 50)
                    commentInsertView.snp.makeConstraints { (make) in
                        make.bottom.equalTo(view.snp.bottom)
                    }
                    commentInsertView.transform = CGAffineTransform(translationX: 0, y: -(keyboardRectangle.height))
                }
            )
        }
    }
    
    @objc override func keyboardDown() {
        self.view.transform = .identity
        commentViewConstraint?.update(offset: 0)
        commentInsertView.isHidden = true
    }
}
