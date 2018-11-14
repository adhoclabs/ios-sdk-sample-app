//
//  NumberTableViewCell.swift
//  BurnerSDK
//
//  Created by William Carter on 3/19/18.
//  Copyright © 2018 Burner. All rights reserved.
//

import UIKit

protocol NumberCellDelegate: class {
    func cellDidSelect(burner: Burner);
}

class NumberTableViewCell: UITableViewCell {

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var expiresLabel: UILabel!
    @IBOutlet weak var textsLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    weak var delegate: NumberCellDelegate?
    
    @IBOutlet weak var minutesLabel: UILabel!
    var burner: Burner?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(_ burner: Burner) {
        
        self.burner = burner
        
        // set up burner info
        
        if let formatted = String.format(phoneNumber: burner.phoneNumber) {
            phoneLabel.text = formatted
        } else {
            phoneLabel.text = burner.phoneNumber
        }
        
        copyButton.layer.cornerRadius = 5
        selectButton.layer.cornerRadius = 5
        
        // check if date is earlier than the creation date
        // if it is, it's Unlimited
        let expires = Date.init(timeIntervalSince1970: TimeInterval(burner.expires))
        let created = Date.init(timeIntervalSince1970: TimeInterval(burner.dateCreated))
        
        if expires < created {
            expiresLabel.text = "Auto-renews"
            textsLabel.text = "Unlimited"
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        let dateString = dateFormatter.string(from: expires)
        expiresLabel.text = "Expires: \(dateString)"
        
        let minutes = burner.remainingMinutes
        let texts = burner.remainingTexts
        
        textsLabel.text = "\(texts) texts"
        minutesLabel.text = "\(minutes) minutes"
    }

    @IBAction func copyTapped(_ sender: Any) {
        
        if let burner = burner {
            UIPasteboard.general.string = burner.phoneNumber
        }
    }
    @IBAction func selectTapped(_ sender: Any) {
        
        if let burner = burner {
            delegate?.cellDidSelect(burner: burner)
        }
    }
    
    

}
