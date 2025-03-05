//
//  HistoryVC.swift
//  ThemePokerDash
//
//  Created by Theme Poker Dash on 2025/3/5.
//


import UIKit

var arrHistory: [String] = []{
    didSet{
        UserDefaults.standard.setValue(arrHistory, forKey: "history")
    }
}

class ThemePokerHistoryVC: UIViewController {

    @IBOutlet weak var field: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        field.text = arrHistory.joined(separator: "\n")
    }
    


}
