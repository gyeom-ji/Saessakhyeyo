//
//  DictViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/04.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit

class DictViewController: UIViewController {
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    init(viewMode: ViewMode){
        self.viewMode = viewMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            DictTableViewCell.self,
            forCellReuseIdentifier: DictTableViewCell.identifier
        )
        tableView.sectionIndexColor = .saessakDarkGreen
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.setValue("취소", forKey: "cancelButtonText")
        searchBar.placeholder = "식물을 검색해주세요(초성 검색 가능)"
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.backgroundColor = UIColor.saessakBeige
        searchBar.searchTextField.textColor = .darkGray
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 13)
        searchBar.searchTextField.largeContentImage?.withTintColor(.saessakDarkGreen)
        searchBar.searchTextField.leftView?.tintColor = .saessakDarkGreen
        searchBar.searchTextField.addRightPadding()
        searchBar.searchTextField.delegate = self
        
        if let button = searchBar.searchTextField.value(forKey: "_clearButton") as? UIButton {
            button.setImage(UIImage(systemName: "x.circle"), for: .normal)
            button.tintColor = .saessakDarkGreen
        }
        
        return searchBar
    }()
    
    private lazy var dictLogoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "dictLogo")
        
        return imgView
    }()
    
    private let disposeBag = DisposeBag()
    private var dictVM: DictViewModel?
    private var viewMode = ViewMode.main
    private var speciesCellTap = PublishRelay<[Int]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setView()
        bindVM()
    }

    private func setView(){
        
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
        
        view.addSubview(dictLogoImgView)
        dictLogoImgView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(45)
        }
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(dictLogoImgView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-60)
            make.height.equalTo(40)
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(15)
            make.trailing.leading.bottom.equalToSuperview()
        }
        
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.prefersGrabberVisible = true
        }
    }
    
    private func bindVM(){
        self.dictVM = DictViewModel()
        
        let input = DictViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in self.viewMode},
            searchBarEditEvent: self.searchBar.rx.text.orEmpty.debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance).distinctUntilChanged().asObservable(),
            speciesCellTap: self.speciesCellTap.asObservable())
        
        let output = self.dictVM!.transform(from: input, disposeBag: self.disposeBag)
        
        output.didLoadData
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        output.textFieldText
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.searchBar.searchTextField.text = value
            }).disposed(by: disposeBag)
        
        output.presentReadDictView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                let vc = ReadDictViewController()
                vc.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
        output.dismissView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}

extension DictViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dictVM!.isFiltering ? 1 : self.dictVM!.sectionDict.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  self.dictVM!.isFiltering ? self.dictVM!.filterdDict.count : self.dictVM!.sectionDict[section].dict.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DictTableViewCell.identifier,
            for: indexPath
        ) as? DictTableViewCell,
              let dict = self.dictVM!.isFiltering ? self.dictVM!.filterdDict[indexPath.row] : self.dictVM?.sectionDict[indexPath.section].dict[indexPath.row] else {
            return UITableViewCell()
        }
        cell.updateUI(plantName: dict.plantName, plantImg: dict.imgUrl)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dictVM!.isFiltering ? "" : self.dictVM?.sectionDict[section].title
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return  self.dictVM!.isFiltering ? [""] : self.dictVM?.sectionDict.map { $0.title }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        speciesCellTap.accept([self.dictVM!.isFiltering ? 1 : 0, indexPath.section, indexPath.row])
        self.dismiss(animated: true)
    }
}

extension DictViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
