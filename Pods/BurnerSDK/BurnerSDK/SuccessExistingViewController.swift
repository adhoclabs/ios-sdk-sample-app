//
//  SuccessExistingViewController.swift
//  BurnerSDK
//
//  Created by William Carter on 2/26/18.
//  Copyright © 2018 Burner. All rights reserved.
//

import UIKit

class SuccessExistingViewController: UIViewController {

    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize action button.
        
        actionButton.layer.cornerRadius = 10
        actionButton.layer.masksToBounds = true
        actionButton.setTitle(BurnerAppManager.openOrDownloadText(), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionTapped(_ sender: Any) {
        
        // dismiss
        dismiss(animated: true, completion: nil)
        
        BurnerAppManager.openAppOrStore()
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
