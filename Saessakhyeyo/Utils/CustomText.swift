//
//  CustomText.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/04.
//

import Foundation
import UIKit

extension UITextView {
    func setAttributedText(_ text: String, fontSize: CGFloat, kern: CGFloat, lineSpacing: CGFloat){
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kern, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: fontSize), range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
}

extension UILabel {
    func setAttributedText(_ text: String, fontSize: CGFloat, kern: CGFloat, lineSpacing: CGFloat){
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kern, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: fontSize), range: NSRange(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
    }
}

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addRightPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
    
    func addleftimage(image:UIImage) {
        let leftimage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width + 80, height: image.size.height))
        leftimage.image = image
        leftimage.tintColor = .saessakDarkGreen
        self.leftView = leftimage
        self.leftViewMode = .always
    }
}

extension String {
    private var koreanUnicodeRange: (Int, Int) {
        return (0xAC00, 0xD7AF)
    }
    
    var consonant: String? {
        guard utf16.count > 0 else {
            return nil
        }
        
        let consonant = Hangul().CHO
        let code = utf16[utf16.startIndex]
        
        if code >= UInt16(koreanUnicodeRange.0) && code <= UInt16(koreanUnicodeRange.1) {
            let unicode = code - UInt16(koreanUnicodeRange.0)
            let consonantIndex = Int(unicode / 21 / 28)
            return consonant[consonantIndex]
        }
        return String(first!)
    }
    
    func isChosung() -> Bool {
        // 해당 문자열이 초성으로 이뤄져있는지 확인하기.
        var isChosung = false
        for char in self {
            // 검색하는 문자열전체가 초성인지 확인하기
            if 0 < Hangul().CHO.filter({ $0.contains(char)}).count {
                isChosung = true
            } else {
                // 초성이 아닌 문자섞이면 false 끝.
                isChosung = false
                break
            }
        }
        return isChosung
    }
    
    func chosungCheck() -> String {
        var result = ""
        // 문자열하나씩 짤라서 확인
        for char in self {
            let octal = char.unicodeScalars[char.unicodeScalars.startIndex].value
            if 44032...55203 ~= octal { // 유니코드가 한글값 일때만 분리작업
                let index = (octal - 0xac00) / 28 / 21
                result = result + Hangul().CHO[Int(index)]
            }
        }
        
        return result
    }
    
    func matchString (_string : String) -> String { // 문자열 변경 실시
        let strArr = Array(_string) // 문자열 한글자씩 확인을 위해 배열에 담는다
        
        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣]$" // 정규식 : 한글만 허용 (공백, 특수문자 제거)
        // 문자열 길이가 한개 이상인 경우만 패턴 검사 수행
        var resultString = ""
        if strArr.count > 0 {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                var index = 0
                while index < strArr.count { // string 문자 하나 마다 개별 정규식 체크
                    let checkString = regex.matches(in: String(strArr[index]), options: [], range: NSRange(location: 0, length: 1))
                    if checkString.count == 0 {
                        index += 1 // 정규식 패턴 외의 문자가 포함된 경우
                    }
                    else { // 정규식 포함 패턴의 문자
                        resultString += String(strArr[index]) // 리턴 문자열에 추가
                        index += 1
                    }
                }
            }
            return resultString
        }
        else {
            return _string // 원본 문자 다시 리턴
        }
    }
}
