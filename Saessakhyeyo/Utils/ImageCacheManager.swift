//
//  ImageCacheManager.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/08/01.
//

import Foundation
import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
