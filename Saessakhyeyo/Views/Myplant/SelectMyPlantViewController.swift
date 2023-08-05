//
//  SelectMyPlantViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/29.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit

class SelectMyPlantViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            SelectMyPlantTableViewCell.self,
            forCellReuseIdentifier: SelectMyPlantTableViewCell.identifier
        )
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let disposeBag = DisposeBag()
    private var myPlantVM: SelectMyPlantViewModel?
    var selectPlant = PublishSubject<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setView()
        bindVM()
        bindUI()
    }
    
    private func setView(){
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.leading.bottom.equalToSuperview()
        }
        
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium(), .large()]
            sheetPresentationController.prefersGrabberVisible = true
        }
    }
    
    private func bindVM(){
        self.myPlantVM = SelectMyPlantViewModel()
        
        let input = SelectMyPlantViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in},
            selectPlant: self.selectPlant.asObserver())
        
        let output = self.myPlantVM!.transform(from: input, disposeBag: self.disposeBag)
        
        output.dismissView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func bindUI(){
        myPlantVM?.myPlantList
            .bind(to: tableView.rx.items(cellIdentifier: SelectMyPlantTableViewCell.identifier, cellType: SelectMyPlantTableViewCell.self)) { index, myPlant, cell in
                cell.updateUI(plantName: myPlant.nickname, plantImg: myPlant.imgUrl, dday: myPlant.dday ?? "")
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.selectPlant.onNext(value.row)
            }).disposed(by: disposeBag)
    }
}
