//
//  UserDefaults.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/08/01.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.com.gyeomji.saesakheyo"
        return UserDefaults(suiteName: appGroupId)!
    }
}
