//
//  ResponseModel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/02.
//

import Foundation

struct ResponseModel<T : Codable>: Codable {
    var data: T?
    let success: Bool?
    var message: String
    var status: Int
}
