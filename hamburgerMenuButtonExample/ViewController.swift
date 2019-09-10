//
//  ViewController.swift
//  hamburgerMenuButtonExample
//
//  Created by 박성원 on 06/09/2019.
//  Copyright © 2019 Kakao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    @IBAction func showMenu(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let vc: SecondViewController = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

extension ViewController:  UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension ViewController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let navigationController: UINavigationController
        let fromView: UIView
        let toView: UIView
        
        if transitionContext.viewController(forKey: .from)!.isKind(of: UINavigationController.self) {
            navigationController = transitionContext.viewController(forKey: .from)! as! UINavigationController
            fromView = navigationController.topViewController!.view!
            toView = transitionContext.viewController(forKey: .to)!.view!
        }
        else {
            navigationController = transitionContext.viewController(forKey: .to)! as! UINavigationController
            fromView = transitionContext.viewController(forKey: .from)!.view!
            toView = navigationController.topViewController!.view!
        }

        let isPresentingDrawer = fromView == view
        let drawerView = isPresentingDrawer ? toView : fromView
        
        if isPresentingDrawer {
            transitionContext.containerView.addSubview(drawerView)
        }
        
        let drawerSize = CGSize(
            width: UIScreen.main.bounds.size.width,
            height: UIScreen.main.bounds.size.height)

        let offScreenDrawerFrame = CGRect(origin: CGPoint(x: drawerSize.width * -1, y:0), size: drawerSize)
        let onScreenDrawerFrame = CGRect(origin: .zero, size: drawerSize)
        
        drawerView.frame = isPresentingDrawer ? offScreenDrawerFrame : onScreenDrawerFrame
        
        let animationDuration = transitionDuration(using: transitionContext)

        UIView.animate(withDuration: animationDuration, animations: {
            drawerView.frame = isPresentingDrawer ? onScreenDrawerFrame : offScreenDrawerFrame
        }, completion: { (success) in
            if !isPresentingDrawer {
                drawerView.removeFromSuperview()
            }

            transitionContext.completeTransition(success)
        })
    }
}
