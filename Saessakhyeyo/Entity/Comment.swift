//
//  Comment.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/01.
//

import Foundation

struct Comment: Codable {
    var dateTime: String
    var userId: Int
    var id: Int
    var content: String
    var userName: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case dateTime
        case userId = "user_id"
        case content
        case userName
    }
    
    init(){
        self.dateTime = ""
        self.userId = -1
        self.id = -1
        self.content = ""
        self.userName = ""
    }
}
