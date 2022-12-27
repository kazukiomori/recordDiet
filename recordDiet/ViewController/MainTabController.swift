//
//  MainTabController.swift
//  recordDiet
//
//  Created by Kazuki Omori on 2022/12/28.
//

import UIKit

class MainTabController: UITabBarController {
     
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    // MARK: - Function
    func configureViewController() {
        view.backgroundColor = .white
        
        let unselectedTopImage = UIImage(systemName: "chart.line.downtrend.xyaxis.circle")!
        let selectedTopImage = UIImage(systemName: "chart.line.downtrend.xyaxis.circle.fill")!
        let unselectedCalendarImage = UIImage(systemName: "calendar.circle")!
        let selectedCalendarImage = UIImage(systemName: "calendar.circle.fill")!
        
        let Top = navigationControllerFunction(unselectedImage: unselectedTopImage, selectedImage: selectedTopImage, rootViewController: TopViewController())
        
        let Calendar = navigationControllerFunction(unselectedImage: unselectedCalendarImage, selectedImage: selectedCalendarImage, rootViewController: CalendarViewController())
        
        viewControllers = [Top, Calendar]
    }
    
    func navigationControllerFunction(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }

}
