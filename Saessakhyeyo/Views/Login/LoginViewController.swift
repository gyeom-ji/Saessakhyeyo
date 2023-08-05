//
//  LoginViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/01.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit

class LoginViewController: UIViewController {
    private var kakaoLoginBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakao_login_medium_narrow"), for: .normal)
        return button
    }()
    
    private var topBarImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "bar")
        return imgView
    }()
    
    private var bottomBarImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "bar")
        return imgView
    }()

    private var saesakLogoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "saesakhaeyo")
        return imgView
    }()
    
    private var saesakImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "saesak_smile")
        return imgView
    }()
    
    private var launchLogoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "launchLogo")
        return imgView
    }()

    private let disposeBag = DisposeBag()
    private var loginVM = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
        bindVM()
    }
    
    private func setView(){
        
        view.backgroundColor = .white
        view.addSubview(topBarImgView)
        topBarImgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(70)
            make.width.equalToSuperview().offset(-20)
        }
        
        view.addSubview(launchLogoImgView)
        launchLogoImgView.snp.makeConstraints { (make) in
            make.top.equalTo(topBarImgView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(190)
            make.width.equalTo(170)
        }
        
        view.addSubview(saesakImgView)
        saesakImgView.snp.makeConstraints { (make) in
            make.centerY.centerX.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        view.addSubview(saesakLogoImgView)
        saesakLogoImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(saesakImgView.snp.bottom)
            make.width.equalTo(130)
            make.height.equalTo(50)
        }
        
        view.addSubview(kakaoLoginBtn)
        kakaoLoginBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(saesakLogoImgView.snp.bottom).offset(20)
        }
        view.addSubview(bottomBarImgView)
        bottomBarImgView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-35)
            make.width.equalToSuperview().offset(-20)
        }
    }
    
    private func bindVM(){
        
        let input = LoginViewModel.Input(viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in}, loginBtnTap: self.kakaoLoginBtn.rx.tap.asObservable())
        
        let output = self.loginVM.transform(from: input, disposeBag: self.disposeBag)
        
        output.presentMainView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                guard let nextVC = self.storyboard?.instantiateViewController(identifier: "TabBarController")as? UITabBarController else {return}
                nextVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                owner.present(nextVC, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        output.isBtnHidden
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.kakaoLoginBtn.isHidden = value
            }).disposed(by: disposeBag)
    }
    
}
