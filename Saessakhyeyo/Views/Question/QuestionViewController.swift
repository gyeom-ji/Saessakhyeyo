//
//  QuestionViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/01.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit

class QuestionViewController: UIViewController {
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
       // tableView.dataSource = self
       // tableView.delegate = self
        tableView.register(
            QuestionTableViewCell.self,
            forCellReuseIdentifier: QuestionTableViewCell.identifier
        )
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private lazy var sortBtn: UIButton = {
        let button = UIButton()
        button.setTitle("   최신 날짜순", for: .normal)
      
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitleColor(.saessakDarkGreen, for: .normal)
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.down", withConfiguration: config), for: .normal)
        button.tintColor = .saessakDarkGreen
        
        var menuItems: [UIAction] {
            return [
                UIAction(title: "최신 날짜순", image: UIImage(systemName: "list.dash"), handler: { (_) in self.sortBtn.setTitle("   최신 날짜순", for: .normal); self.sortByDateBtnTap.onNext(true);}),
                UIAction(title: "댓글순", image: UIImage(systemName: "text.bubble"), handler: { (_) in self.sortBtn.setTitle("   댓글순", for: .normal); self.sortByCommentBtnTap.onNext(true);}),
                
            ]
        }

        button.menu = UIMenu(image: nil, identifier: nil, options: [], children: menuItems )
        button.showsMenuAsPrimaryAction = true
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private lazy var insertBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pencilIcon")?.resizeImageTo(size: CGSize(width: 45, height: 45)), for: .normal)
        return button
    }()
    
    private lazy var searchBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        button.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: config), for: .normal)
        button.setTitle(" 질문을 검색해주세요", for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = .saessakDarkGreen
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.setTitleColor(.saessakDarkGreen, for: .normal)
        button.backgroundColor = .saessakBeige

        return button
    }()
    
    private lazy var questionLogoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "questionLogo")
        
        return imgView
    }()
    
    private let disposeBag = DisposeBag()
    private var questionVM: QuestionViewModel?
    private var sortByDateBtnTap = PublishSubject<Bool>()
    private var sortByCommentBtnTap = PublishSubject<Bool>()
    private var selectQuestion = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setView()
        bindVM()
    }

    private func setView(){
        view.backgroundColor = .white
        view.addSubview(insertBtn)
        insertBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(10)
        }
        
        view.addSubview(questionLogoImgView)
        questionLogoImgView.snp.makeConstraints { make in
            make.centerY.equalTo(insertBtn.snp.centerY)
            make.trailing.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(45)
        }
        
        view.addSubview(searchBtn)
        searchBtn.snp.makeConstraints { make in
            make.top.equalTo(questionLogoImgView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-60)
            make.height.equalTo(40)
        }
        
        view.addSubview(sortBtn)
        sortBtn.snp.makeConstraints { make in
            make.top.equalTo(searchBtn.snp.bottom).offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(sortBtn.snp.bottom).offset(15)
            make.trailing.leading.bottom.equalToSuperview()
        }
    }

    private func bindVM(){
        self.questionVM = QuestionViewModel()
        
        let input = QuestionViewModel.Input(
            insertBtnTap: self.insertBtn.rx.tap.asObservable(),
            searchBtnTap: self.searchBtn.rx.tap.asObservable(),
            sortByDateBtnTap: self.sortByDateBtnTap.asObservable(),
            sortByCommentBtnTap: self.sortByCommentBtnTap.asObservable(),
            selectQuestion: self.selectQuestion.asObserver(),
            refreshTableView:  refreshControl.rx.controlEvent(.valueChanged).asObservable())
        
        let output = self.questionVM!.transform(from: input, disposeBag: self.disposeBag)
        
        output.presentInsertView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, _ in
                let vc = InsertQuestionViewController(viewMode: .create)
                vc.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
        output.presentSearchView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, _ in
                let vc = SearchQuestionViewController()
                vc.modalPresentationStyle = .pageSheet
                owner.present(vc, animated: true)
            }).disposed(by: disposeBag)
        
        output.presentReadQuestionView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, _ in
                let vc = ReadQuestionViewController()
                vc.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
        output.updateQuestionRow
            .asDriver(onErrorJustReturn: -1)
            .drive(with: self, onNext: { owner, value in
                print(value)
                owner.tableView.reloadRows(at: [IndexPath(row: value, section: 0)], with: .automatic)
            }).disposed(by: disposeBag)
        
        output.deleteQuestionRow
            .asDriver(onErrorJustReturn: -1)
            .drive(with: self, onNext: { owner, value in
                owner.tableView.deleteRows(at: [IndexPath(row: value, section: 0)], with: .automatic)
            }).disposed(by: disposeBag)
        
        output.endRefreshing
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.refreshControl.endRefreshing()
            }).disposed(by: disposeBag)
        
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
    
    func popView() {
       self.navigationController?.popViewController(animated: true)
    }
}
