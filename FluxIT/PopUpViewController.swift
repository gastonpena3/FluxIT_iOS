//
//  PopUpViewController.swift
//  FluxIT
//
//  Created by Gastón Pena on 30/1/17.
//  Copyright © 2017 Gastón Pena. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
    @IBOutlet weak var messagePopUp: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimated()
    }
    
    @IBAction func closePopUp(_ sender: UIButton) {
        self.removeAnimated()
    }
    
    //SHOW POP UP
    func showAnimated() {
        self.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
        })
    }
    
    //REMOVE POP UP
    func removeAnimated() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
            self.view.alpha = 0.0
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
        })
    }
    
}
