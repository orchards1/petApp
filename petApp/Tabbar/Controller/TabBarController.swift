//
//  TabBarController.swift
//  petApp
//
//  Created by Michael Louis on 21/01/21.
//

import UIKit

class TabBarController: UIViewController {
    
    var halfModalTransitioningDelegate: HalfModalTransitioningDelegate?
    
    @IBAction func addDidTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "toHalfModal", sender: nil)
        
    }
    var selectedIndex: Int = 0
    var previousIndex: Int = 0
    
    @IBAction func tabChanged(sender:UIButton) {
        previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        buttons[previousIndex].isSelected = false
        let previousVC = viewControllers[previousIndex]
        
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        sender.isSelected = true
        
        let vc = viewControllers[selectedIndex]
        vc.view.frame = UIApplication.shared.windows[0].frame
        vc.didMove(toParent: self)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        
        self.view.bringSubviewToFront(tabView)
    }
    
    @IBOutlet var tabView: UIView!
    @IBOutlet var buttons:[UIButton]!
    var viewControllers = [UIViewController]()
    static let firstVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTableViewController")
    static let secondVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers.append(TabBarController.firstVC)
        viewControllers.append(TabBarController.secondVC)
        
        buttons[selectedIndex].isSelected = true
        buttons[0].contentMode = .center
        buttons[1].contentMode = .center
        buttons[0].setImage(#imageLiteral(resourceName: "home_selected"), for: .selected)
        buttons[0].setImage(#imageLiteral(resourceName: "Home_unselected"), for: .normal)
        buttons[1].setImage(#imageLiteral(resourceName: "profile_selected"), for: .selected)
        buttons[1].setImage(#imageLiteral(resourceName: "profile_unselected"), for: .normal)
        tabChanged(sender: buttons[selectedIndex])
        
        tabView.layer.shadowColor = UIColor.black.cgColor
        tabView.layer.shadowOpacity = 0.16
        tabView.layer.shadowOffset = CGSize(width: -1, height: 1)
        tabView.layer.shadowRadius = 2
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toHalfModal")
        {
        self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: segue.destination)
        
        segue.destination.modalPresentationStyle = .custom
        segue.destination.transitioningDelegate = self.halfModalTransitioningDelegate
        }
        
    }
}
