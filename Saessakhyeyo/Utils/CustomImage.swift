//
//  UIImage.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/03.
//

import Foundation
import UIKit
import RxSwift
import Alamofire

extension UIImage {
    func resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

extension UIImageView {
    
    func loadImage(_ url: String) {
        DispatchQueue.global(qos: .background).async {
            let cachedKey = NSString(string: url)
            
            if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
                DispatchQueue.main.async {
                    self.image = cachedImage
                }
                return
            }
            
            guard let url = URL(string: url) else { return }
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        ImageCacheManager.shared.setObject(image, forKey: cachedKey)
                        self.image = image
                    }
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.image = UIImage(named: "saesak_basics")
                }
                return
            }
        }
    }
    
    func loadDataImage(type: String, id: Int, isUpdate: Bool) {
        
        DispatchQueue.global(qos: .background).async {
           
            let cachedKey = NSString(string: "\(type) - \(id)")
            
            if !isUpdate {
                if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
                    DispatchQueue.main.async {
                        self.image = cachedImage
                    }
                    return
                }
            }
            guard let url = URL(string: APIConstrants.baseURL+"/\(type)/readImage/\(id)") else { return }
            let header : HTTPHeaders = ["Content-Type" : "application/json" ]
            
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                ImageCacheManager.shared.setObject(image, forKey: cachedKey)
                                self.image = image
                            }
                        }
                    case .failure(let error):
                        print(error)
                        DispatchQueue.main.async { [weak self] in
                            self?.image = UIImage(named: "saesak_basics")
                        }
                        return
                    }
                }
        }
    }
}
