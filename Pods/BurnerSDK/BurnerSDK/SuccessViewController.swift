//
//  SuccessViewController.swift
//  BurnerSDK
//
//  Created by William Carter on 1/9/18.
//  Copyright © 2018 Burner. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

    @IBOutlet weak var downloadButton: UIButton!
    
    var burner: Burner?
    
    let privacyInfoText = "will not have access to your calls and texts"

    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var expiresLabel: UILabel!
    @IBOutlet weak var privacyWarningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // customize download button
        
        downloadButton.layer.cornerRadius = 10
        downloadButton.layer.masksToBounds = true
        downloadButton.setTitle(BurnerAppManager.openOrDownloadText(), for: .normal)
        
        // customize copy button
        
        copyButton.layer.cornerRadius = 10
        copyButton.layer.masksToBounds = true
        
        // hide privacy warning label by default
        
        privacyWarningLabel.isHidden = true
        
        // show if we don't have the messages scope
        
        if !Creds.shared.hasConnectScope() {

            // by default use the client id as the name
            if let name = BurnerSDK.shared.clientName {
                privacyWarningLabel.text = "\(name) \(privacyInfoText)"
                privacyWarningLabel.isHidden = false
            }
            
            // if there's been a custom display name added,
            // use that instead
            if let clientId = BurnerSDK.shared.clientId {
                privacyWarningLabel.text = "\(clientId.uppercased()) \(privacyInfoText)"
                privacyWarningLabel.isHidden = false
            }
            
        }
        
        // set up burner info
        
        if let b = burner {
            
            if let formatted = String.format(phoneNumber: b.phoneNumber) {
                phoneLabel.text = formatted
            } else {
                phoneLabel.text = b.phoneNumber
            }
        
            // check if date is earlier than the creation date
            // if it is, it's Unlimited
            let expires = Date.init(timeIntervalSince1970: TimeInterval(b.expires))
            let created = Date.init(timeIntervalSince1970: TimeInterval(b.dateCreated))
            
            if expires < created {
                expiresLabel.text = "Auto-renews"
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            let dateString = dateFormatter.string(from: expires)
            expiresLabel.text = dateString
        }
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        
        // dismiss
        dismiss(animated: true, completion: nil)
        
        BurnerAppManager.openAppOrStore()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func copyTapped(_ sender: Any) {
        
        if let burner = burner {
            UIPasteboard.general.string = burner.phoneNumber
        }
        
    }
    
}


