//
//  GetStartedVC.swift
//  ThemePokerDash
//
//  Created by Theme Poker Dash on 2025/3/5.
//


import UIKit
import Reachability

class ThemePokerGetStartedVC: UIViewController {
    
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var field: UITextView!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var reachability: Reachability!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.startAnimations()
        }
        
        self.activityView.hidesWhenStopped = true
        themePokerLoadAdsData()
    }
    
    private func themePokerLoadAdsData() {
        guard themePokerNeedLoadAdBannData() else { return }
        
        do {
            reachability = try Reachability()
        } catch {
            print("Unable to create Reachability: \(error)")
            return
        }
        
        if reachability.connection == .unavailable {
            reachability.whenReachable = { [weak self] _ in
                self?.reachability.stopNotifier()
                self?.themePokerGetLoadAdsData()
            }
            reachability.whenUnreachable = { _ in }
            
            do {
                try reachability.startNotifier()
            } catch {
                print("Unable to start notifier: \(error)")
            }
        } else {
            themePokerGetLoadAdsData()
        }
    }

    private func themePokerGetLoadAdsData() {
        activityView.startAnimating()
        
        guard let bundleId = Bundle.main.bundleIdentifier else {
            activityView.stopAnimating()
            return
        }
        
        let hostUrl = themePokerHostUrl()
        let endpoint = "https://open.livelys\(hostUrl)/open/themePokerGetLoadAdsData"
        
        guard let url = URL(string: endpoint) else {
            print("Invalid URL: \(endpoint)")
            activityView.stopAnimating()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "appSystemName": UIDevice.current.systemName,
            "appModelName": UIDevice.current.model,
            "appKey": "50ee218cd8754dd78badb8f5f70cf5bd",
            "appPackageId": bundleId,
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            activityView.stopAnimating()
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    self.activityView.stopAnimating()
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        let dictionary: [String: Any]? = resDic["data"] as? Dictionary
                        if let dataDic = dictionary {
                            if let adsData = dataDic["jsonObject"] as? [String] {
                                UserDefaults.standard.set(adsData, forKey: "ADSdatas")
                                self.themePokerShowAdView(adsData[0])
                                return
                            }
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    self.activityView.stopAnimating()
                
                } catch {
                    print("Failed to parse JSON:", error)
                    self.activityView.stopAnimating()
                 
                }
            }
        }
        
        task.resume()
    }
    
    private func setupInitialState() {
        imgLogo.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        imgLogo.alpha = 0
        
        imgBg.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        imgBg.alpha = 0
        
        field.alpha = 0
        field.text = """
        Welcome to Theme Poker Dash!
        
        Theme Poker Dash is an innovative poker-based game that brings a refreshing twist to traditional card games. It blends strategic gameplay with interactive elements, making it engaging for both poker enthusiasts and casual players. The game offers a dynamic experience with various themes, challenges, and an immersive card-hunting mechanism.

        """
    }
    
    private func startAnimations() {
        animateBackground()
        animateLogo()
        animateText()
    }
    
    private func animateBackground() {
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.imgBg.transform = .identity
            self.imgBg.alpha = 1
        }
        
        startBackgroundPulse()
        startBackgroundShimmer()
    }
    
    private func startBackgroundPulse() {
        UIView.animate(withDuration: 3.0, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut]) {
            self.imgBg.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }
    
    private func startBackgroundShimmer() {
        let shimmerView = UIView(frame: imgBg.bounds)
        shimmerView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        shimmerView.alpha = 0
        imgBg.addSubview(shimmerView)
        
        UIView.animate(withDuration: 2.5, delay: 0, options: [.repeat, .curveEaseInOut]) {
            shimmerView.alpha = 0.4
            shimmerView.frame.origin.x = self.imgBg.frame.width
        } completion: { _ in
            shimmerView.frame.origin.x = -self.imgBg.frame.width
        }
    }
    
    private func animateLogo() {
        UIView.animate(withDuration: 1.2, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.imgLogo.transform = .identity
            self.imgLogo.alpha = 1
        } completion: { _ in
            self.startLogoFloatingAnimation()
            self.startLogoRotationAnimation()
            self.startLogoGlowEffect()
        }
    }
    
    private func startLogoFloatingAnimation() {
        let floatAnimation = CABasicAnimation(keyPath: "position.y")
        floatAnimation.duration = 2.0
        floatAnimation.fromValue = self.imgLogo.center.y
        floatAnimation.toValue = self.imgLogo.center.y - 10
        floatAnimation.autoreverses = true
        floatAnimation.repeatCount = .infinity
        floatAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        self.imgLogo.layer.add(floatAnimation, forKey: "floatingAnimation")
    }
    
    private func startLogoRotationAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = -0.05
        rotationAnimation.toValue = 0.05
        rotationAnimation.duration = 2.5
        rotationAnimation.autoreverses = true
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        self.imgLogo.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    private func startLogoGlowEffect() {
        let glowView = UIView(frame: imgLogo.frame)
        glowView.backgroundColor = .clear
        glowView.layer.shadowColor = UIColor.white.cgColor
        glowView.layer.shadowOffset = .zero
        glowView.layer.shadowRadius = 10
        glowView.layer.shadowOpacity = 0
        view.insertSubview(glowView, belowSubview: imgLogo)
        
        UIView.animate(withDuration: 2.0, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut]) {
            glowView.layer.shadowOpacity = 0.8
        }
    }
    
    private func animateText() {
        let finalText = field.text ?? ""
        field.text = ""
        field.alpha = 1
        
        var charIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if charIndex < finalText.count {
                let index = finalText.index(finalText.startIndex, offsetBy: charIndex)
                self.field.text?.append(finalText[index])
                charIndex += 1
            } else {
                timer.invalidate()
                self.addTextPulseAnimation()
            }
        }
    }
    
    private func addTextPulseAnimation() {
        UIView.animate(withDuration: 1.5, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut]) {
            self.field.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imgLogo.layer.removeAllAnimations()
        imgBg.layer.removeAllAnimations()
    }
    
}
