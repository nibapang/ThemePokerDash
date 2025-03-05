//
//  StartGameVC.swift
//  ThemePokerDash
//
//  Created by Theme Poker Dash on 2025/3/5.
//


import UIKit

class ThemePokerStartGameVC: UIViewController {

    @IBOutlet weak var cv: UICollectionView!
    
    var vc = ThemePokerDashGameVC()
    
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cv.delegate = self
        cv.dataSource = self
        
        vc = storyboard?.instantiateViewController(withIdentifier: "PokerGameVC")as! ThemePokerDashGameVC
    }
    
    @IBAction func btnStart(_ sender: UIButton) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ThemePokerStartGameVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameThemeCell", for: indexPath)as! GameThemeCell
        cell.img.image = UIImage(named: "V \(indexPath.item+1)")
        
        if indexPath == selectedIndex {
            cell.img.layer.borderWidth = 6
            cell.img.layer.borderColor = UIColor.btn.cgColor
        } else {
            cell.img.layer.borderWidth = 0
            cell.img.layer.borderColor = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let s = collectionView.bounds.size.width/2
        return CGSize(width: s, height: s/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let oldIndex = selectedIndex
        selectedIndex = indexPath
        
        if let old = oldIndex {
            collectionView.reloadItems(at: [old])
        }
        collectionView.reloadItems(at: [indexPath])
        
        vc.bgId = indexPath.row+1
    }
}
