//
//  AVCaptureDevice.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/02.
//

import Foundation
import RxSwift
import AVFoundation
import Photos

extension AVCaptureDevice {
    static var authorized: Observable<Bool> {
      
      return Observable.create { observer in
        
        DispatchQueue.main.async {
            switch authorizationStatus(for: .video) {

          case .authorized:
            observer.onNext(true)
          
          case .notDetermined,
               .restricted,
               .denied:
            observer.onNext(false)
            // 다시 권한 요청
              PHPhotoLibrary.requestAuthorization { newStatus in
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
