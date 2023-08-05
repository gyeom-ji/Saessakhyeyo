//
//  TabBarViewController.swift
//  Saessakhyeyo
//
//  Created by 윤겸지 on 2023/07/04.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class TabbarViewController: UITabBarController {
    
    static var tabBarTap = BehaviorRelay<Int>(value:0)
    private let disposeBag = DisposeBag()
    
    var defaultIndex = 0 {
        didSet {
            self.selectedIndex = defaultIndex
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.selectedIndex = defaultIndex
    }
}

extension TabbarViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let homeNavigationController = UINavigationController()
        let homeTabController = HomeViewController()
        homeNavigationController.addChild(homeTabController)
        homeNavigationController.tabBarItem.image = UIImage(named: "saesak")?.resizeImageTo(size: CGSize(width: 80, height: 60))
        homeNavigationController.tabBarItem.selectedImage = UIImage(named: "saesak")?.resizeImageTo(size: CGSize(width: 80, height: 60))
        
        let insertNavigationController = UINavigationController()
        let insertTabController = InsertPlantViewController(viewMode: .create)
        insertNavigationController.addChild(insertTabController)
        insertNavigationController.tabBarItem.image = UIImage(named: "plusIcon")?.resizeImageTo(size: CGSize(width: 80, height: 60))
        insertNavigationController.tabBarItem.selectedImage = UIImage(named: "plusIcon")?.resizeImageTo(size: CGSize(width: 80, height: 60))
        
        let questionNavigationController = UINavigationController()
        let questionTabController = QuestionViewController()
        questionNavigationController.addChild(questionTabController)
        questionNavigationController.tabBarItem.image = UIImage(named: "questionIcon")?.resizeImageTo(size: CGSize(width: 80, height: 60))
        questionNavigationController.tabBarItem.selectedImage = UIImage(named: "questionIcon")?.resizeImageTo(size: CGSize(width: 80, height: 60))
        
        let dictNavigationController = UINavigationController()
        let dictTabController = DictViewController(viewMode: .main)
        dictNavigationController.addChild(dictTabController)
        dictNavigationController.tabBarItem.image = UIImage(named: "dictIcon")?.resizeImageTo(size: CGSize(width: 80, height: 60))
        dictNavigationController.tabBarItem.selectedImage = UIImage(named: "dictIcon")?.resizeImageTo(size: CGSize(width: 80, height: 60))
        
        let myPageNavigationController = UINavigationController()
        let myPageTabController = MypageViewController()
        myPageNavigationController.addChild(myPageTabController)
        myPageNavigationController.tabBarItem.image = UIImage(named: "mypageIcon")?.resizeImageTo(size: CGSize(width: 80, height: 60))
        myPageNavigationController.tabBarItem.selectedImage = UIImage(named: "mypageIcon")?.resizeImageTo(size: CGSize(width: 80, height: 60))
        
        
        let viewControllers = [homeNavigationController,dictNavigationController, insertNavigationController, questionNavigationController, myPageNavigationController]
        self.setViewControllers(viewControllers, animated: true)
        
        let tabBar: UITabBar = self.tabBar
        tabBar.backgroundColor = UIColor.saessakBeige
        tabBar.barTintColor = UIColor.saessakBeige
        ///선택되었을 때 타이틀 컬러
        tabBar.tintColor = UIColor.saessakDarkGreen
        ///선택안된거 타이틀 컬러
        tabBar.unselectedItemTintColor = UIColor.lightGray
        tabBar.isHidden = false
    }
}

extension TabbarViewController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        TabbarViewController.tabBarTap.accept(tabBar.items!.firstIndex(of: item) ?? 0)
    }
}
