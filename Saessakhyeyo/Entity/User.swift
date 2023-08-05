//
//  User.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/01.
//

import Foundation

struct User: Codable{
    var id: Int
    var userName: String
    var plantCount: Int
}

extension User {
    static var empty: User {
        return User(id: -1, userName: "", plantCount: -1)
    }
}
