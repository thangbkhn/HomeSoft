//
//  HelpViewController.swift
//  HomeCare
//
//  Created by Nguyen Van Tho on 4/10/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class HelpViewController: UIPageViewController{
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController(number:"1"),
                self.newColoredViewController(number:"2"),
                self.newColoredViewController(number:"3")]
    }()
    
    private func newColoredViewController(number: String) -> UIViewController {
        return UIStoryboard(name: "Help", bundle: nil) .
            instantiateViewController(withIdentifier: "screen\(number)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Shadow navigation line
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIColor.gray.as1ptImage()
        
        self.dataSource = self
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = GlobalUtil.getMainColor()
        let backButton = UIBarButtonItem(title: "Hướng dẫn sử dụng", style: UIBarButtonItemStyle.done, target: nil, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20)], for: .normal)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
}
extension HelpViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.showTabar(isShow: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.showTabar(isShow: false)
    }
    func showTabar(isShow:Bool)  {
        let animatedTabBar = self.tabBarController as! RAMAnimatedTabBarController
        animatedTabBar.animationTabBarHidden(!isShow)
    }
}
