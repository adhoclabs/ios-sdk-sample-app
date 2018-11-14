//
//  WebErrorViewController.swift
//  BurnerSDK
//
//  Created by William Carter on 4/25/18.
//  Copyright © 2018 Burner. All rights reserved.
//

import UIKit

protocol WebErrorDelegate: class {
    func webErrorDidRefresh()
}

class WebErrorViewController: UIViewController {

    weak var delegate: WebErrorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        
        delegate?.webErrorDidRefresh()
        
    }
    
}
