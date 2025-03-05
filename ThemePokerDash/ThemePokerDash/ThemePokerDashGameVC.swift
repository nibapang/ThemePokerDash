//
//  PokerGameVC.swift
//  ThemePokerDash
//
//  Created by Theme Poker Dash on 2025/3/5.
//


import UIKit
import SpriteKit

class ThemePokerDashGameVC: UIViewController {
    
    @IBOutlet weak var viewGame: UIView!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblCards: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgBg: UIImageView!
    
    var bgId = 1
    
    let arrCards = [
        "🂢", "🂣", "🂤", "🂥", "🂦", "🂧", "🂨", "🂩", "🂪", "🂫", "🂭", "🂮", "🂡",
        "🂲", "🂳", "🂴", "🂵", "🂶", "🂷", "🂸", "🂹", "🂺", "🂻", "🂽", "🂾", "🂱",
        "🃂", "🃃", "🃄", "🃅", "🃆", "🃇", "🃈", "🃉", "🃊", "🃋", "🃍", "🃎", "🃁",
        "🃒", "🃓", "🃔", "🃕", "🃖", "🃗", "🃘", "🃙", "🃚", "🃛", "🃝", "🃞", "🃑",
    ]
    
    private var currentScore = 0
    private var remainingCards: [String] = []
    private var gameTimer: Timer?
    private var timeRemaining = 60
    private var currentLevel = 1
    private var cardsInPlay: [UILabel] = []
    private var cardSize: CGFloat = 60
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
        lblTime.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imgBg.image = UIImage(named: "V \(bgId)")
    }
    
    private func setupGame() {
        currentScore = 0
        remainingCards = arrCards.shuffled()
        timeRemaining = 60
        
        lblScore.text = "Score: 0"
        lblTime.text = "Time: \(timeRemaining)s"
        
        cardsInPlay.forEach { $0.removeFromSuperview() }
        cardsInPlay.removeAll()
        
        let numberOfCards = min(currentLevel * 10, 52)
        lblCards.text = "Cards\nLeft: \(numberOfCards)"
        
        displayCardsForLevel(count: numberOfCards)
        
        startGameTimer()
    }
    
    private func startGameTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            self.lblTime.text = "Time: \(self.timeRemaining)s"
            
            if self.timeRemaining <= 0 {
                self.endGame()
            }
        }
    }
    
    private func displayCardsForLevel(count: Int) {
        let cards = Array(remainingCards.prefix(count))
        
        for card in cards {
            let cardLabel = createCardLabel(with: card)
            viewGame.addSubview(cardLabel)
            cardsInPlay.append(cardLabel)
            
            let xPos = CGFloat.random(in: cardSize/2...viewGame.bounds.width-cardSize/2)
            let yPos = CGFloat.random(in: cardSize/2...viewGame.bounds.height-cardSize/2)
            cardLabel.center = CGPoint(x: xPos, y: yPos)
            
            let rotation = CGFloat.random(in: -CGFloat.pi/4...CGFloat.pi/4)
            cardLabel.transform = CGAffineTransform(rotationAngle: rotation)
            
            let scale = CGFloat.random(in: 0.8...1.2)
            cardLabel.transform = cardLabel.transform.scaledBy(x: scale, y: scale)
            
            cardLabel.alpha = CGFloat.random(in: 0.6...0.9)
        }
    }
    
    private func createCardLabel(with card: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: cardSize, height: cardSize))
        label.text = card
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 40)
        label.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(_:)))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }
    
    @objc private func handleCardTap(_ gesture: UITapGestureRecognizer) {
        guard timeRemaining > 0,
              let tappedLabel = gesture.view as? UILabel else { return }
        
        let scorePopup = UILabel()
        scorePopup.text = "+10"
        scorePopup.textColor = .green
        scorePopup.font = .boldSystemFont(ofSize: 24)
        scorePopup.sizeToFit()
        scorePopup.center = tappedLabel.center
        viewGame.addSubview(scorePopup)
        
        UIView.animate(withDuration: 0.5, animations: {
            scorePopup.transform = CGAffineTransform(translationX: 0, y: -50)
            scorePopup.alpha = 0
        }) { _ in
            scorePopup.removeFromSuperview()
        }
        
        var oldScore = currentScore
        currentScore += 10
        
        UIView.animate(withDuration: 0.2, animations: {
            self.lblScore.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                oldScore += 1
                self.lblScore.text = "Score: \(oldScore)"
                if oldScore >= self.currentScore {
                    timer.invalidate()
                    UIView.animate(withDuration: 0.1) {
                        self.lblScore.transform = .identity
                    }
                }
            }
        }
        
        UIView.animate(withDuration: 0.5, 
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.3,
            options: .curveEaseOut,
            animations: {
                tappedLabel.transform = tappedLabel.transform.scaledBy(x: 2.0, y: 2.0)
                tappedLabel.alpha = 0
                
                let additionalRotation = CGFloat.random(in: -CGFloat.pi/2...CGFloat.pi/2)
                tappedLabel.transform = tappedLabel.transform.rotated(by: additionalRotation)
        }) { _ in
            tappedLabel.removeFromSuperview()
            if let index = self.cardsInPlay.firstIndex(of: tappedLabel) {
                self.cardsInPlay.remove(at: index)
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.lblCards.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.lblCards.text = "Cards Left: \(self.cardsInPlay.count)"
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.lblCards.transform = .identity
                }
            }
            
            if self.cardsInPlay.isEmpty {
                self.levelComplete()
            }
        }
    }
    
    private func levelComplete() {
        gameTimer?.invalidate()
        gameTimer = nil
        
        let timeBonus = timeRemaining * 5
        let alert = UIAlertController(
            title: "Level \(currentLevel) Complete!",
            message: "Score: \(currentScore)\nTime Bonus: \(timeBonus)",
            preferredStyle: .alert
        )
        
        currentScore += timeBonus
        
        // Add to history
        let historyEntry = "Level \(currentLevel) Complete - Score: \(currentScore) (Including Time Bonus: \(timeBonus))"
        arrHistory.insert(historyEntry, at: 0)
        
        alert.addAction(UIAlertAction(title: "Next Level", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.currentLevel += 1
            self.setupGame()
        })
        
        alert.addAction(UIAlertAction(title: "Exit", style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    private func endGame() {
        gameTimer?.invalidate()
        gameTimer = nil
        
        let alert = UIAlertController(
            title: "Game Over!",
            message: "Final Score: \(currentScore)\nLevel Reached: \(currentLevel)",
            preferredStyle: .alert
        )
        
        // Add to history
        let historyEntry = "Game Over - Final Score: \(currentScore), Reached Level: \(currentLevel)"
        arrHistory.insert(historyEntry, at: 0)
        
        alert.addAction(UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.currentLevel = 1
            self.setupGame()
        })
        
        alert.addAction(UIAlertAction(title: "Exit", style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
    
}
