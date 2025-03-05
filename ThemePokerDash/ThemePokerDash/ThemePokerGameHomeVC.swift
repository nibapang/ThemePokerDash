//
//  HomeVC.swift
//  ThemePokerDash
//
//  Created by Theme Poker Dash on 2025/3/5.
//


import UIKit
import StoreKit

class ThemePokerGameHomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func btnRate(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
    
    
}
