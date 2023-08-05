//
//  ReadDictViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/04.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

class ReadDictViewController: UIViewController {
    
    private lazy var dictLogoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "dictLogo")
        
        return imgView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            DetailDictTableViewCell.self,
            forCellReuseIdentifier: DetailDictTableViewCell.identifier
        )
        tableView.layer.cornerRadius = 15
        tableView.backgroundColor = .saessakLightGreen
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var plantNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var plantImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor.clear.cgColor
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 60
        return imgView
    }()
    
    private lazy var backBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.forward", withConfiguration: config), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .saessakDarkGreen
        return button
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .saessakBeige
        return view
    }()
    
    private let disposeBag = DisposeBag()
    private var dictVM: ReadDictViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            make.bottom.equalToSuperview().offset(-20)
        }
        
        headerView.addSubview(dictLogoImgView)
        dictLogoImgView.snp.makeConstraints { make in
            make.centerY.equalTo(backBtn.snp.centerY)
            make.trailing.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(45)
        }
        
        view.addSubview(plantImgView)
        plantImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.width.height.equalTo(120)
        }
        
        view.addSubview(plantNameLabel)
        plantNameLabel.snp.makeConstraints { make in
            make.top.equalTo(plantImgView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(plantNameLabel.snp.bottom).offset(20)
            make.trailing.leading.bottom.equalToSuperview()
        }
    }

    private func bindVM(){
        self.dictVM = ReadDictViewModel()
        
        let input = ReadDictViewModel.Input(
            backBtnTap: self.backBtn.rx.tap.asObservable())
        
        let output = self.dictVM!.transform(from: input, disposeBag: self.disposeBag)
        
        output.dismissView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        output.plantImg
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                if value != "" {
                    owner.plantImgView.loadImage(value)
                }
            }).disposed(by: disposeBag)
        
        output.plantName
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.plantNameLabel.text = value
            }).disposed(by: disposeBag)
    }
    
    private func bindUI() {
        dictVM?.selectPlantDict
            .bind(to: tableView.rx.items(cellIdentifier: DetailDictTableViewCell.identifier, cellType: DetailDictTableViewCell.self)) { index, dict, cell in
                let title = dict["title"]
                let content = dict["text"]
                cell.updateUI(title: title ?? "", content: content ?? "")
            }.disposed(by: disposeBag)
    }
}
