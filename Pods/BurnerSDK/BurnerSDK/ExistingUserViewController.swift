//
//  ExistingUserViewController.swift
//  BurnerSDK
//
//  Created by William Carter on 3/19/18.
//  Copyright © 2018 Burner. All rights reserved.
//

import UIKit

class ExistingUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NumberCellDelegate {

    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var numbers: [Burner] = [Burner]()
    var completion: ((_ burner: Burner?, _ oauth: OAuth?, _ error: Error?) -> Void)?
    var token: String?
    var oauth: OAuth?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 120
        
        guard let t = token else {
            return
        }
        
        oauth = OAuth.init(access_token: t, connected_burners: [ConnectedBurners](), expires_in: 0, scope: "", token_type: "")
        
        loadingView.startAnimating()
        
        HttpManager.shared.getBurnerNumbersFor(oauth!) { (burners, error) in
            
            if let bs = burners {
                self.numbers = bs
            }
            
            DispatchQueue.main.async(execute: {() -> Void in
                self.loadingView.stopAnimating()
                self.loadingView.isHidden = true
                self.tableView.reloadData()
            })
            
        }
        
        // change button state
        
        openButton.setTitle(BurnerAppManager.openOrDownloadText(), for: .normal)
        
    }

    //MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneNumberCell", for: indexPath) as! NumberTableViewCell
        
        let b = numbers[indexPath.row]
        cell.configure(b)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let burner = numbers[indexPath.row]
        
        if let completionHandler = completion {
            completionHandler(burner, self.oauth!, nil)
        }
        
        // copy + dismiss
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        return UIView()
    }
    
    //MARK: Actions
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openOrDownloadAction(_ sender: Any) {
        
        BurnerAppManager.openAppOrStore()
        
    }
    //MARK: Cell Delegate
    
    func cellDidSelect(burner: Burner) {
        
        if let completionHandler = completion {
            completionHandler(burner, self.oauth!, nil)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
