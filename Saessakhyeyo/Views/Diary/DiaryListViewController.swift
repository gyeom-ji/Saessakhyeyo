//
//  DiaryListViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/25.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit

class DiaryListViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            DiaryListTableViewCell.self,
            forCellReuseIdentifier: DiaryListTableViewCell.identifier
        )
        
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var backBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = .saessakDarkGreen
        return button
    }()
    
    private lazy var deleteBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "trashIcon"), for: .normal)
        return button
    }()
    
    private lazy var diaryListLogoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "diaryListLogo")
        
        return imgView
    }()
    
    private lazy var myPlantImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 35
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    private lazy var myPlantNickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .saessakBeige
        return view
    }()
    
    private let disposeBag = DisposeBag()
    private var diaryVM: DiaryListViewModel?
    private var selectDiary = PublishSubject<Int>()
    private var deleteDiary = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setView()
        bindGesture(disposeBag: disposeBag)
        bindVM()
        bindUI()
    }
    
    private func setView(){
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.leading.equalToSuperview()
        }
        
        headerView.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(60)
            make.leading.equalToSuperview().offset(10)
        }
        
        headerView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { make in
            make.centerY.equalTo(backBtn.snp.centerY)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        headerView.addSubview(diaryListLogoImgView)
        diaryListLogoImgView.snp.makeConstraints { make in
            make.centerY.equalTo(backBtn.snp.centerY)
            make.leading.equalTo(backBtn.snp.trailing).offset(15)
            make.width.equalTo(100)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        view.addSubview(myPlantImgView)
        myPlantImgView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(70)
        }
        
        view.addSubview(myPlantNickNameLabel)
        myPlantNickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(myPlantImgView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(myPlantNickNameLabel.snp.bottom).offset(15)
            make.trailing.leading.bottom.equalToSuperview()
        }
    }
    
    private func bindVM(){
        self.diaryVM = DiaryListViewModel()
        
        let input = DiaryListViewModel.Input(
            diaryCellTap: self.selectDiary.asObserver(),
            deleteDiary: self.deleteDiary.asObserver(),
            backBtnTap: self.backBtn.rx.tap.asObservable(),
            deleteBtnTap: self.deleteBtn.rx.tap.asObservable())
        
        let output = self.diaryVM!.transform(from: input, disposeBag: self.disposeBag)
        
        output.didLoadPlantData
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, value in
                owner.myPlantImgView.loadImage(value[1])
                owner.myPlantNickNameLabel.text = value[0]
            }).disposed(by: disposeBag)
        
        output.dismissView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        output.presentDiaryView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.presentDiaryView()
            }).disposed(by: disposeBag)

        output.showDeleteView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, _ in
                if owner.tableView.isEditing {
                    owner.tableView.setEditing(false, animated: true)
                    owner.deleteBtn.setImage(UIImage(named: "trashIcon"), for: .normal)
                } else {
                    owner.tableView.setEditing(true, animated: true)
                    owner.deleteBtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
                    owner.deleteBtn.tintColor = .saessakDarkGreen
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindUI(){
        diaryVM?.diaryList
            .bind(to: tableView.rx.items(cellIdentifier: DiaryListTableViewCell.identifier, cellType: DiaryListTableViewCell.self)) { index, diary, cell in
                cell.updateUI(isImg: diary.isImg, cond: diary.cond, act1: diary.activity1, act2: diary.activity2, act3: diary.activity3, weather: diary.weather, date: diary.date, content: diary.content, diaryId: diary.id, isUpdate: diary.isUpdateImg)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.selectDiary.onNext(value.row)
            }).disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.deleteDiary.onNext(value.row)
            }).disposed(by: disposeBag)
    }
    
    func presentDiaryView() {
        let vc = DiaryViewController(viewMode: .update)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
