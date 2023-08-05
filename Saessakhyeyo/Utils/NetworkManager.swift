//
//  NetworkManager.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/06/18.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire
import AlamofireImage

struct Resource<T> {
    let url: URL
    var method: HTTPMethod
    var headers: HTTPHeaders
    var body: Parameters?
    var imgPath: Data?
    var fileName: Int?
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func getRequest<T: Decodable>(resource: Resource<T>)  -> Observable<T> {
        return Observable.create { observer -> Disposable in
            AF.request(resource.url, method: resource.method, parameters: resource.body, encoding: JSONEncoding.default, headers: resource.headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                    case .failure(let error):
                        print(error)
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    func getImg(resource: Resource<Data>)  -> Observable<Data> {
        return Observable.create { observer -> Disposable in
            AF.request(resource.url, method: resource.method, parameters: resource.body, encoding: JSONEncoding.default, headers: resource.headers)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                    case .failure(let error):
                        print(error)
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    func getUpload<T: Decodable>(resource: Resource<T>)  -> Observable<T> {
        return Observable.create { observer -> Disposable in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(resource.imgPath!, withName: "img_path", fileName:  "\(resource.fileName!).jpg")
            }, to: resource.url, method: resource.method, headers: resource.headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                    case .failure(let error):
                        print(error)
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
