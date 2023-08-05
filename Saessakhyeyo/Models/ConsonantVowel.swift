//
//  ConsonantVowel.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/05.
//

import Foundation

extension CharacterSet{
    static var modernHangul: CharacterSet{
        return CharacterSet(charactersIn: ("가".unicodeScalars.first!)...("힣".unicodeScalars.first!))
    }
}

public class ConsonantVowel{
    // UTF-8 기준
    let INDEX_HANGUL_START:UInt32 = 44032  // "가"
    let INDEX_HANGUL_END:UInt32 = 55199    // "힣"
    
    let CYCLE_CHO :UInt32 = 588
    let CYCLE_JUNG :UInt32 = 28
    
    let hangul = Hangul()
    
    // 주어진 "단어"를 자모음으로 분해해서 리턴하는 함수
    func getJamo(_ input: String) -> [String] {
        var jamo : [String] = []
        //let word = input.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .punctuationCharacters)
        for scalar in input.unicodeScalars{
            var temp = getJamoFromOneSyllable(scalar) ?? [""]
            for i in 0..<temp.count{
                jamo.append( temp[i])
            }
        }
        return jamo
    }
    
    // 주어진 "코드의 음절"을 자모음으로 분해해서 리턴하는 함수
    private func getJamoFromOneSyllable(_ n: UnicodeScalar) -> [String]?{
        var temp : [String] = []
        if CharacterSet.modernHangul.contains(n){
            let index = n.value - INDEX_HANGUL_START
            var cho = hangul.CHO[Int(index / CYCLE_CHO)]
            var jung = hangul.JUNG[Int((index % CYCLE_CHO) / CYCLE_JUNG)]
            var jong = hangul.JONG[Int(index % CYCLE_JUNG)]
          
            
            if let disassembledJong = hangul.JONG_DOUBLE[jong] {
                jong = disassembledJong
            }
            if cho != "" {
                temp.append(cho)
            }
            if jung != "" {
                temp.append(jung)
            }
            if jong != "" {
                temp.append(jong)
            }
            return temp
        }else{
            temp.append(String(UnicodeScalar(n)))
            return temp
        }
    }
}
