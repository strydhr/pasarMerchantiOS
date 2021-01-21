//
//  WalkthroughVC.swift
//  ThePasar
//
//  Created by Satyia Anand on 30/11/2020.
//  Copyright © 2020 Satyia Anand. All rights reserved.
//

import UIKit

protocol WalkthroughPageVCDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageVC: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {

    var walkthroughdelegate: WalkthroughPageVCDelegate?
    
    var pageHeading = ["Post Homecooked Food","Track Your Sale Stock","One Touch Order System","Monthly Sales"]
    var subheading = ["Share your homecooked meals with your communities","The stock count and order system would make your life easier","The easy to navigate order system makes it convenient to know about your incoming orders","We tabulate monthly chart of your product sales so you can view your best selling homecooked products"]
    var imgStrs = ["hint1","hint2","hint3","hint4"]
    var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let startingVC = contentViewController(at: 0){
            setViewControllers([startingVC], direction: .forward, animated: true, completion: nil)
        }
    }
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentVC).index
        index -= 1
        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentVC).index
        index += 1
        
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed:Bool){
        if completed{
            if let contentVC = pageViewController.viewControllers?.first as? WalkthroughContentVC{
                currentIndex = contentVC.index
                walkthroughdelegate!.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }
    

    func contentViewController(at index:Int) -> WalkthroughContentVC?{
        if index < 0 || index >= pageHeading.count{
            return nil
        }
        if let pageContentViewController = storyboard?.instantiateViewController(identifier: "WalkthroughContentVC")as? WalkthroughContentVC{
            pageContentViewController.heading = pageHeading[index]
            pageContentViewController.imgStr = imgStrs[index]
            pageContentViewController.subheading = subheading[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
       
    }
    
    func forwardPage(){
        currentIndex += 1
        if let next = contentViewController(at: currentIndex){
            setViewControllers([next], direction: .forward, animated: true, completion: nil)
        }
    }
}
