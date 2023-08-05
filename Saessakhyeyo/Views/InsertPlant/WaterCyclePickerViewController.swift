//
//  WaterCyclePickerViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/07.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

class WaterCyclePickerViewController: UIViewController {

    private lazy var waterCyclePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()

    private lazy var alertView = CustomAlertView()
    
    private let disposeBag = DisposeBag()
    private var waterCycleValue = 0
    var selectWaterCycle = BehaviorRelay<Int>(value: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        bindUI()
    }
}

extension WaterCyclePickerViewController {

    private func setView(){

        view.backgroundColor = .clear

        view.addSubview(alertView)
        alertView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }

    private func bindUI(){
        alertView.updateUI(alertText: "물주는 주기를 선택해주세요", content: waterCyclePicker)
        
        alertView.saveBtnTap
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.selectWaterCycle.accept(owner.waterCycleValue)
                owner.dismiss(animated: true)
            }).disposed(by: disposeBag)

        alertView.cancelBtnTap
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}

extension WaterCyclePickerViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)일"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.waterCycleValue = row
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 30
    }
}


