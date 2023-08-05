//
//  SearchQuestionViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/02.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

class SearchQuestionViewController: UIViewController{
    
    private lazy var categorySegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["전체", "식물관리", "아파요", "식물종찾기", "꿀팁공유"])
        segment.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], for: .normal)
        segment.layer.frame = CGRect(x: 0, y: 64, width: 375, height: 36)
        let backgroundImage = UIImage(named: "backColorImg")
        segment.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        let selectImage = UIImage(named: "colorImg")
        segment.setBackgroundImage(selectImage, for: .selected, barMetrics: .default)
        segment.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        
        let deviderImage = UIImage()
        segment.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 13, weight: .semibold)], for: .selected)
        
        return segment
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 13)
        textField.textColor = .darkGray
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .saessakBeige
        textField.addRightPadding()
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        textField.addleftimage(image: UIImage(systemName: "magnifyingglass", withConfiguration: config)!)
        textField.placeholder = "질문을 검색해주세요"
        return textField
    }()
    
    private lazy var searchBtn: UIButton = {
        let button = UIButton()
        button.setTitle("검색", for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.saessakDarkGreen
        
        return button
    }()
    
    private lazy var clearBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        button.setImage(UIImage(systemName: "xmark.circle", withConfiguration: config), for: .normal)
        button.tintColor = .saessakDarkGreen
        button.backgroundColor = .clear
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            QuestionTableViewCell.self,
            forCellReuseIdentifier: QuestionTableViewCell.identifier
        )
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let disposeBag = DisposeBag()
    private var questionVM: SearchQuestionViewModel?
    private var selectQuestion = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        bindVM()
        bindUI()
    }
}

extension SearchQuestionViewController {
    
    private func setView(){
        
        hideKeyboardWhenTappedAround()
        
        if let sheetPresentationController = sheetPresentationController {
            //bar
            sheetPresentationController.prefersGrabberVisible = true
        }
        
        view.backgroundColor = .white
        clearBtn.isHidden = true
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(view.snp.width).offset(-100)
            make.height.equalTo(45)
        }
        
        textField.addSubview(clearBtn)
        clearBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(searchBtn)
        searchBtn.snp.makeConstraints { make in
            make.centerY.equalTo(textField.snp.centerY)
            make.height.equalTo(45)
            make.leading.equalTo(textField.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(categorySegment)
        categorySegment.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchBtn.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(categorySegment.snp.bottom).offset(20)
        }
    }
    
    private func bindVM(){
        self.questionVM = SearchQuestionViewModel()
        
        let input = SearchQuestionViewModel.Input(
            searchBtnTap: self.searchBtn.rx.tap.asObservable().map { [weak self] in self!.textField.text! },
            textFieldEdit: self.textField.rx.text.orEmpty.asObservable(),
            clearBtnTap: self.clearBtn.rx.tap.asObservable(),
            segmentTap: self.categorySegment.rx.selectedSegmentIndex.asObservable(),
            selectQuestion: self.selectQuestion.asObserver())
        
        let output = self.questionVM!.transform(from: input, disposeBag: self.disposeBag)
        
        output.hideKeyboard
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.view.endEditing(value)
            }).disposed(by: disposeBag)
        
        output.hideClearBtn
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.clearBtn.isHidden = value
            }).disposed(by: disposeBag)
        
        output.textFieldText
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.textField.text = value
            }).disposed(by: disposeBag)
        
        output.presentReadQuestionView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, _ in
                let vc = ReadQuestionViewController()
                vc.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func bindUI(){
        questionVM?.questionList
            .bind(to: tableView.rx.items(cellIdentifier: QuestionTableViewCell.identifier, cellType: QuestionTableViewCell.self)) { index, question, cell in
                cell.updateUI(isImg: question.isImg, content: question.content, commentCount: "\(question.commentCnt)", questionId: question.id, isUpdate: question.isUpdateImg)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.selectQuestion.onNext(value.row)
            }).disposed(by: disposeBag)
    }
}
