//
//  PHPhotoLibrary.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/02.
//

import Foundation
import RxSwift
import Photos

extension PHPhotoLibrary {
  static var authorized: Observable<Bool> {
    
    return Observable.create { observer in
      
      DispatchQueue.main.async {
        switch authorizationStatus() {
        
        case .authorized:
          observer.onNext(true)
        
        case .notDetermined,
             .restricted,
             .denied,
             .limited:
          observer.onNext(false)
          // 다시 권한 요청
          requestAuthorization { newStatus in
            observer.onNext(newStatus == .authorized)
            observer.onCompleted()
          }
        @unknown default:
          print("Deal with unkown case")
        }
      }
      return Disposables.create()
    }
  }
}
