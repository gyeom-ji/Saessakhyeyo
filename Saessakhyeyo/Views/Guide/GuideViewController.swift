//
//  GuideViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/30.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxGesture

class GuideViewController: UIViewController {
    
    private var pages: [String] = ["guidePage", "guidePage2", "guidePage3","guidePage4", "guidePage5"]
    
    private lazy var backBtn: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = .saessakDarkGreen
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.saessakDarkGreen, for: .normal)
        button.backgroundColor = .saessakBeige
        return button
    }()
    
    private var guideImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "guidePage")
        return imgView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = self.pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .saessakLightGreen
        pageControl.currentPageIndicatorTintColor = .saessakDarkGreen
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setView()
        bindUI()
    }
}

extension GuideViewController {
    
    private func setView(){
        
        view.backgroundColor = .white
        view.addSubview(guideImgView)
        guideImgView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.leading.equalToSuperview()
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.top.equalTo(guideImgView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(pageControl.snp.trailing).offset(10)
            make.centerY.equalTo(pageControl.snp.centerY)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
    }
    
    private func bindUI(){
        backBtn.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        Observable
          .merge(
            self.view.rx.gesture(.swipe(direction: .left)).asObservable(),
            self.view.rx.gesture(.swipe(direction: .right)).asObservable()
          )
          .bind(with: self, onNext: { owner, value in
              guard let gesture = value as? UISwipeGestureRecognizer else { return }
              switch gesture.direction {
              case .left:
                  owner.pageControl.currentPage = owner.pageControl.currentPage != 4 ?  owner.pageControl.currentPage + 1 : 4
              case .right:
                  owner.pageControl.currentPage = owner.pageControl.currentPage != 0 ?  owner.pageControl.currentPage - 1 : 0
              default:
                break
              }
              owner.guideImgView.image = UIImage(named: owner.pages[owner.pageControl.currentPage])
          }).disposed(by: disposeBag)
    }
}
