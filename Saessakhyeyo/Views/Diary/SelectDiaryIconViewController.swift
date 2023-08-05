//
//  SelectDiaryIconViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/25.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

class SelectDiaryIconViewController: UIViewController {

    static var identifier: String {
        return String(describing: Self.self)
    }
    
    init(diaryIconList: [String], alertTitle: String){
        self.diaryIconList.accept(diaryIconList)
        self.alertTitle = alertTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 70, height: 70)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            DiaryIconCollectionViewCell.self,
            forCellWithReuseIdentifier: DiaryIconCollectionViewCell.identifier
        )
        return collectionView
    }()

    private lazy var alertView = CustomAlertView()
    
    private let disposeBag = DisposeBag()
    var selectValue = PublishRelay<[String]>()
    private var selectIcon : [String] = []
    private var diaryIconList = BehaviorRelay<[String]>(value: [])
    private var alertTitle = String()
    
    private var selectIndexPath : [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        bindUI()
    }
}

extension SelectDiaryIconViewController {

    private func setView(){

        view.backgroundColor = .clear

        view.addSubview(alertView)
        alertView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.height.equalTo(160)
            make.width.equalTo(250)
        }
        
        if alertTitle.contains("활동"){
            collectionView.allowsMultipleSelection = true
        } else {
            collectionView.allowsMultipleSelection = false
        }
    }

    private func bindUI(){
        alertView.updateUI(alertText: alertTitle, content: collectionView)
        
        alertView.saveBtnTap
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                for i in 0..<owner.selectIndexPath.count {
                    owner.selectIcon.append(owner.diaryIconList.value[owner.selectIndexPath[i].row])
                }
                owner.selectValue.accept(owner.selectIcon)
                owner.dismiss(animated: true)
            }).disposed(by: disposeBag)

        alertView.cancelBtnTap
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        diaryIconList
            .bind(to: collectionView.rx.items(cellIdentifier: DiaryIconCollectionViewCell.identifier, cellType: DiaryIconCollectionViewCell.self)) { index, icon, cell in
                cell.updateUI(img: icon)
            }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                if owner.collectionView.allowsMultipleSelection {
                    if owner.collectionView.indexPathsForSelectedItems!.count > 3 {
                        owner.collectionView.deselectItem(at: owner.selectIndexPath[0], animated: true)
                        owner.selectIndexPath.remove(at: 0)
                    }
                    owner.selectIndexPath.append(value)
                } else {
                    owner.selectIndexPath = [value]
                }
            }).disposed(by: disposeBag)
    }
}
