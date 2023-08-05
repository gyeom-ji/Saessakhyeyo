//
//  Question.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/01.
//

import Foundation
import UIKit

struct Question: Codable {
    var id: Int
    var dateTime : String
    var imgData: Data?
    var userId: Int
    var category: String
    var content: String
    var userName: String
    var commentCnt: Int
    var isImg: Bool
    var isUpdateImg: Bool
    
    init()
    {
        id = -1
        dateTime = ""
        userId = -1
        category = ""
        content = ""
        userName = ""
        commentCnt = 0
        isImg = false
        isUpdateImg = true
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case dateTime
        case userId = "user_id"
        case category
        case content
        case userName
        case commentCnt
        case isImg = "img"
        case isUpdateImg = "updateImg"
    }
    
    init(id: Int, dateTime : String, userId: Int, category: String, content: String, userName: String, commentCount:Int, imgData: Data? = nil, isImg: Bool, isUpdateImg: Bool){
        self.id = id
        self.dateTime = dateTime
        self.userId = userId
        self.category = category
        self.content = content
        self.userName = userName
        self.commentCnt = commentCount
        self.imgData = imgData
        self.isImg = isImg
        self.isUpdateImg = isUpdateImg
    }
    
}

