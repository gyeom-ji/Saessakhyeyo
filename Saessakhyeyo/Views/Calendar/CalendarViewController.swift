//
//  CalendarViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/29.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit
import FSCalendar

class CalendarViewController: UIViewController {
    
    private lazy var backBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = .saessakDarkGreen
        return button
    }()
    
    private lazy var myPlantImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 22.5
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    private var calLogoImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "calendarLogo")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var myPlantNickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var myPlantDdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .saessakDarkGreen
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private var showPlantListBtn: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 11, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.down", withConfiguration: config), for: .normal)
        button.tintColor = .saessakDarkGreen
        return button
    }()
    
    private lazy var insertBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pencilIcon")?.resizeImageTo(size: CGSize(width: 50, height: 40)), for: .normal)
        return button
    }()
    
    private lazy var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 14)
        calendar.contentMode = .scaleToFill
        calendar.backgroundColor = .white
        calendar.headerHeight = 50
        calendar.weekdayHeight = 41
        calendar.placeholderType = .none
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleColor = .saessakDarkGreen
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 17, weight: .medium)
        calendar.appearance.weekdayTextColor = .gray
        calendar.appearance.selectionColor = .saessakBeige
        calendar.appearance.titleWeekendColor = .gray
        calendar.appearance.titleDefaultColor = .gray
        calendar.appearance.titleTodayColor = .saessakDarkGreen
        calendar.appearance.titleSelectionColor = .saessakDarkGreen
        calendar.appearance.todayColor = .none
        calendar.scrollDirection = .horizontal
        calendar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.07).cgColor
        calendar.layer.shadowRadius = 10
        calendar.layer.shadowOpacity = 0.8
        calendar.layer.cornerRadius = 15
        calendar.delegate = self
        calendar.dataSource = self
        return calendar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            CalendarTableViewCell.self,
            forCellReuseIdentifier: CalendarTableViewCell.identifier
        )
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let disposeBag = DisposeBag()
    private var calendarVM: CalendarViewModel?
    private var updatePlanBtnTap = PublishRelay<Int>()
    private var deletePlanBtnTap = PublishRelay<Int>()
    private var didSelectDate = PublishRelay<Date>()
    private var calendarPageDidChange = PublishRelay<[Int]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        bindGesture(disposeBag: disposeBag)
        bindVM()
        bindUI()
    }
}

extension CalendarViewController {
    
    private func setView(){
        
        view.backgroundColor = .white
        
        view.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(10)
        }
        
        view.addSubview(myPlantImgView)
        myPlantImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(backBtn.snp.centerY)
            make.width.height.equalTo(45)
            make.leading.equalTo(backBtn.snp.trailing).offset(15)
        }
        
        view.addSubview(myPlantNickNameLabel)
        myPlantNickNameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(myPlantImgView.snp.centerY)
            make.leading.equalTo(myPlantImgView.snp.trailing).offset(10)
        }
        
        view.addSubview(myPlantDdayLabel)
        myPlantDdayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(myPlantNickNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(myPlantImgView.snp.trailing).offset(10)
        }
        
        view.addSubview(showPlantListBtn)
        showPlantListBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(myPlantNickNameLabel.snp.centerY)
            make.leading.equalTo(myPlantNickNameLabel.snp.trailing).offset(10)
        }
        
        view.addSubview(calLogoImgView)
        calLogoImgView.snp.makeConstraints { make in
            make.centerY.equalTo(backBtn.snp.centerY)
            make.trailing.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(45)
        }
        
        view.addSubview(insertBtn)
        insertBtn.snp.makeConstraints { make in
            make.top.equalTo(calLogoImgView.snp.bottom)
            make.centerX.equalTo(calLogoImgView.snp.centerX)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(insertBtn.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(400)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    private func bindVM(){
        self.calendarVM = CalendarViewModel()
        let input = CalendarViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            showPlantListBtnTap: self.showPlantListBtn.rx.tap.asObservable(),
            insertPlanBtnTap: self.insertBtn.rx.tap.asObservable(),
            backBtnTap: self.backBtn.rx.tap.asObservable(),
            updatePlanBtnTap: self.updatePlanBtnTap.asObservable(),
            deletePlanBtnTap: self.deletePlanBtnTap.asObservable(),
            calendarPageDidChange: self.calendarPageDidChange.asObservable(),
            didSelectDate: self.didSelectDate.asObservable())
    
        let output = self.calendarVM!.transform(from: input, disposeBag: self.disposeBag)
        
        output.didLoadPlantData
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.myPlantNickNameLabel.text = value[0]
                if value[1] == "saesak_basics" {
                    owner.myPlantImgView.image = UIImage(named: value[1])?.resizeImageTo(size: CGSize(width: 30, height: 35))
                } else {
                    owner.myPlantImgView.loadImage(value[1])
                }
                owner.myPlantDdayLabel.text = value[2]
            })
            .disposed(by: disposeBag)
        
        output.presentMyPlantSelectView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.presentMyPlantSelectView()
            })
            .disposed(by: disposeBag)
        
        output.presentPlanView
            .asDriver(onErrorJustReturn: ViewMode.create)
            .drive(with: self, onNext: { owner, value in
                owner.presentPlanView(viewMode: value)
            })
            .disposed(by: disposeBag)
        
        output.hideInsertBtn
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.insertBtn.isHidden = value
            }).disposed(by: disposeBag)
        
        output.dismissView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, value in
                owner.navigationController?.popViewController(animated: value)
            }).disposed(by: disposeBag)
    }
    
    private func bindUI(){
        calendarVM?.planList
            .asDriver()
            .drive(with: self, onNext: { owner, value in
                owner.calendarView.reloadData()
            }).disposed(by: disposeBag)
        
        calendarVM?.filterdPlanList
            .bind(to: tableView.rx.items(cellIdentifier: CalendarTableViewCell.identifier, cellType: CalendarTableViewCell.self)) { index, plan, cell in

                let planText = plan.planType == "water" ? "물주기" : plan.planType == "energy" ? "영양제주기" : plan.planType == "soil" ? "분갈이 하기" : "가지치기"
                let isdone = plan.isDone == false ? "미완료" : "완료"
                
                cell.updateUI(plan: self.calendarVM?.myPlant.nickname == "전체" ? "\(plan.myplantName) \(planText) - \(isdone)" : "\(planText) - \(isdone)", planImg: plan.planType)

                var menuItems: [UIAction] {
                    return [
                        UIAction(title: "수정", image: UIImage(systemName: "pencil"), handler: { (_) in self.updatePlanBtnTap.accept(plan.id)}),
                        UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in self.deletePlanBtnTap.accept(plan.id)}),
                    ]
                }
                
                cell.editBtn.menu = UIMenu(image: nil, identifier: nil, options: [], children: menuItems)
                cell.editBtn.showsMenuAsPrimaryAction = true

            }.disposed(by: disposeBag)
    }
    
    func presentPlanView(viewMode: ViewMode) {
        let vc = PlanViewController(viewMode: viewMode)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    func presentMyPlantSelectView() {
        let vc = SelectMyPlantViewController()
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true)
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        if Calendar.current.isDateInToday(date) {
            return 1
        }
        return 0
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]?{
        if Date() == date{
            return [UIColor.saessakDarkGreen]
        }
        return nil
    }

    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let dateString = dateFormatter.string(from: date)

        for i in 0..<self.calendarVM!.planList.value.count {
            if self.calendarVM!.planList.value[i].date == dateString {
                return UIImage(named: self.calendarVM!.planList.value[i].planType)?.resizeImageTo(size: CGSize(width: 45, height: 50))
            }
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.didSelectDate.accept(date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.calendarPageDidChange.accept([Calendar.current.component(.year, from: calendar.currentPage), Calendar.current.component(.month, from: calendar.currentPage)])
    }
}
