//
//  PlantRegionViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/06.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

class PlantRegionViewController: UIViewController {

    private lazy var regionPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()

    private lazy var alertView = CustomAlertView()
    
    private let disposeBag = DisposeBag()
    private var regionValue = ["강릉시, 강원도", "Gangneung-si, Gangwon-do"]
    var selectRegion = PublishRelay<[String]>() ///[0] = region [1] = regionEng

    var regionList = City()

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        bindUI()
    }
}

extension PlantRegionViewController {

    private func setView(){

        view.backgroundColor = .clear

        view.addSubview(alertView)
        alertView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }

    private func bindUI(){
        alertView.updateUI(alertText: "식물 위치를 선택해주세요", content: regionPicker)
        
        alertView.saveBtnTap
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.selectRegion.accept(owner.regionValue)
                owner.dismiss(animated: true)
            }).disposed(by: disposeBag)

        alertView.cancelBtnTap
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}

extension PlantRegionViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return regionList.region.count
        } else {
            let selectedCity = regionPicker.selectedRow(inComponent: 0)
            return regionList.region[selectedCity].city.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
               return regionList.region[row].name
           } else {
               let selectedCity = regionPicker.selectedRow(inComponent: 0)
               return regionList.region[selectedCity].city[row]
           }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
                regionPicker.selectRow(0, inComponent: 1, animated: false)
            }

            let regionIdx = regionPicker.selectedRow(inComponent: 0)
            let selectedRegion = regionList.region[regionIdx].name
            let cityIdx = regionPicker.selectedRow(inComponent: 1)
            let selectedCity = regionList.region[regionIdx].city[cityIdx]
            let selectedRegionEng = regionList.region[regionIdx].engRegion
            let selectedCityEng = regionList.region[regionIdx].engCity[cityIdx]

        if selectedCity != ""{
           regionValue = ["\(selectedCity), \(selectedRegion)", "\(selectedCityEng), \(selectedRegionEng)"]
        }
        else{
            regionValue = ["\(selectedRegion)", "\(selectedRegionEng)"]
        }
         regionPicker.reloadComponent(1)
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 30
    }
}
