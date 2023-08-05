//
//  User.swift
//  FirstProject
//
//  Created by 윤겸지 on 2022/10/04.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire
import KakaoSDKAuth
import KakaoSDKUser

struct UserModel {
    
    var user = PublishSubject<User>()
    var presentMainView = PublishRelay<Bool>()
    var myPlantCnt = PublishRelay<Int>()
    var isBtnHidden = BehaviorRelay<Bool>(value: true)
    
    private let disposeBag = DisposeBag()
    
    func kakaoLogin() {
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { _, error in
                if let error = error {
                    print("_________login error_________")
                    print(error)
                    
                    self.kakaoLoginVailable()
                    
                } else {
                    print("login success")
                    UserDefaults.shared.set("false", forKey: "guideOn")
                    self.setUserInfo()
                }
            }
        } else {
            UserDefaults.shared.set("true", forKey: "guideOn")
            self.isBtnHidden.accept(false)
            self.kakaoLoginVailable()
        }
    }
    
    func setUserInfo(){
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("get userInfo success.")

                _ = user

                self.insertUser(id: (user?.id)!, nickname: (user?.kakaoAccount?.profile?.nickname)!)
            
                self.presentMainView.accept(true)
            }
        }
    }
    
    func insertUser(id:Int64, nickname: String)  {
        
        let url = APIConstrants.baseURL + "/kakaoLogin"
        
        let body : Parameters = [
            "id" : id,
            "userName" : nickname
        ]
        
        let resource = Resource<User>(url: URL(string: url)!, method: .post, headers: ["Content-Type" : "application/json" ], body: body)
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext: { result in
                UserDefaults.shared.set(result.id, forKey: "id")
                UserDefaults.shared.set(result.userName, forKey: "nickname")
                
                setPlanCheckToServer(userId: result.id)
                setPlantCheckToServer(userId: result.id)
                
                user.onNext(result)
            }).disposed(by: disposeBag)
        
    }
    
    func setPlanCheckToServer(userId: Int) {
        
        let url = APIConstrants.baseURL + "/plan/\(userId)/check"
        
        let resource = Resource<Bool>(url: URL(string: url)!, method: .post, headers: ["Content-Type" : "application/json" ])
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext: { result in
                print(result)
            }).disposed(by: disposeBag)
    }
    
    func setPlantCheckToServer(userId: Int) {
        
        let url = APIConstrants.baseURL + "/my-plant/\(userId)/check"
        
        let resource = Resource<Bool>(url: URL(string: url)!, method: .post, headers: ["Content-Type" : "application/json" ])
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext: { result in
                print(result)
            }).disposed(by: disposeBag)
    }
    
    func getMyPlantCount(userId:Int)
    {
        let url = APIConstrants.baseURL + "/myPage/\(userId)"
        
        let resource = Resource<Int>(url: URL(string: url)!, method: .get, headers: ["Content-Type" : "application/json"])
        
        NetworkManager.shared.getRequest(resource: resource)
            .subscribe(onNext: { result in
                myPlantCnt.accept(result)
            }).disposed(by: disposeBag)
    }
    
    func kakaoLoginVailable(){
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    print(error)
                } else {
                    print("New Kakao Login")
                    
                    //do something
                    _ = oauthToken
                    
                    // 로그인 성공 시
                    UserApi.shared.me { kuser, error in
                        if let error = error {
                            print("------KAKAO : user loading failed------")
                            print(error)
                        } else {
                            print("loginWithKakaoTalk() success.")
                            // do something
                            _ = oauthToken
                            // 어세스토큰
                            let accessToken = oauthToken?.accessToken
                            
                            //카카오 로그인을 통해 사용자 토큰을 발급 받은 후 사용자 관리 API 호출
                            self.setUserInfo()
                        }
                    }
                }
            }
        }
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                
                //do something
                _ = oauthToken
                // 어세스토큰
                let accessToken = oauthToken?.accessToken
                print("aceess ======== " + accessToken!)
                //카카오 로그인을 통해 사용자 토큰을 발급 받은 후 사용자 관리 API 호출
                self.setUserInfo()
            }
        }
    }
}
