//
//  UIViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/02.
//

import Foundation
import UIKit
import RxSwift

extension UIViewController {
    
    func bindGesture(disposeBag: DisposeBag) {
        view.rx.swipeGesture(.right)
            .skip(1)
            .when(.recognized)
            .bind(with: self, onNext: { owner, value in
                owner.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
       
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }
    
    @objc func keyboardDown() {
        self.view.transform = .identity
    }

    func setKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardDown), name: UIResponder.keyboardWillHideNotification, object:nil)
    }
    
    @objc func responseToLeftSwipeGesture(_ gesture: UISwipeGestureRecognizer){
        let swipeGesture = UISwipeGestureRecognizer()
        switch swipeGesture.direction{
        case UISwipeGestureRecognizer.Direction.left:
            let transition = CATransition()
            transition.duration = 0.45
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.popViewController(animated: true)
            
        default:
            break
        }
    }
}
