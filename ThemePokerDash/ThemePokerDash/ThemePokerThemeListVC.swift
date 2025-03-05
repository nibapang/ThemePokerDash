//
//  ThemeListVC.swift
//  ThemePokerDash
//
//  Created by Theme Poker Dash on 2025/3/5.
//


import UIKit

class ThemePokerThemeListVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var imgName: Int = 1{
        didSet{
            if imgName > 14 { imgName = 1 }
            let transition1 = CATransition()
            transition1.duration = 0.5
            transition1.type = CATransitionType.fade
            transition1.subtype = oldValue < imgName ? CATransitionSubtype.fromLeft : CATransitionSubtype.fromRight
            img.layer.add(transition1, forKey: kCATransition)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.push
                transition.subtype = oldValue < self.imgName ? CATransitionSubtype.fromRight : CATransitionSubtype.fromLeft
                self.img.layer.add(transition, forKey: kCATransition)
                
                self.img.image = UIImage(named: "V \(self.imgName)")
            }            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        leftSwipe.direction = .left
        img.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        rightSwipe.direction = .right
        img.addGestureRecognizer(rightSwipe)
        
        img.isUserInteractionEnabled = true
        
        lblTitle.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        
        let alert = UIAlertController(
            title: "♤♢ Welcome To Theme Poker Dash Game Theme♧♡\n",
            message: """
                Swipe Left/Right To View Themes.
                """,
            preferredStyle: .alert
        )
        
        let bg = UIImageView(image: UIImage(named: "bg"))
        bg.frame.size = alert.view.frame.size
        bg.alpha = 1        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            imgName += 1
        case .right:
            imgName = imgName > 1 ? imgName - 1 : 14
        default:
            break
        }
    }
}
