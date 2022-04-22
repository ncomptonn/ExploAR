//
//  MenuViewController.swift
//  ExploAR
//
//  Created by Nicholas Compton on 4/18/22.
//

import UIKit

class MenuViewController: UIViewController, ViewControllerDelegate {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var startButton: UILabel!
    @IBOutlet weak var timeScoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var leaderboardLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    
    var leaderboardEntries: [leaderboardEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MAIN_COLOR_BG
        
        let tapActionStart = UITapGestureRecognizer(target: self, action: #selector(startButtonTap))
        startButton.isUserInteractionEnabled = true
        startButton.addGestureRecognizer(tapActionStart)
        
        let tapActionLeaderboard = UITapGestureRecognizer(target: self, action: #selector(leaderboardButtonTap))
        leaderboardLabel.isUserInteractionEnabled = true
        leaderboardLabel.addGestureRecognizer(tapActionLeaderboard)
        
        timeScoreLabel.isHidden = true
        scoreLabel.isHidden = true
        accuracyLabel.isHidden = true
        
        timeScoreLabel.textColor = YELLOW
        scoreLabel.textColor = YELLOW
        accuracyLabel.textColor = YELLOW
        
        //        let logo = UIImage.gifImageWithName("ShootAR")
        //        let imageView = UIImageView(image: logo)
        //        imageView.frame = CGRect(x: 60, y: 100, width: 300, height: 300)
        //        view.addSubview(imageView)
        
    }
    
    @objc func startButtonTap() {
        performSegue(withIdentifier: "toGame", sender: nil)
    }
    
    @objc func leaderboardButtonTap() {
        performSegue(withIdentifier: "toLeaderboard", sender: nil)
    }
    
    func sendGameInformation(time: Double, ammo: Int, numTargets: Int, accuracy: Double) {
        let timeScoreMutliplier = -0.25
        let ammoScoreMultiplier = 2
        let targetScoreMultiplier = 2.25
        
        let targetScore = Float(numTargets) * Float(targetScoreMultiplier)
        let timeScore = Float(time) * Float(timeScoreMutliplier)
        let ammoScore = Float(ammo) * Float(ammoScoreMultiplier)
       
        var score = (targetScore + timeScore + ammoScore) * 1000
        
        if (score < 0) {score = 0.0}
        self.timeScoreLabel.text = "Time: " + String(format:"%.2f", time) + "(s)"
        self.scoreLabel.text = "Score: " + String(Int(score))
        self.accuracyLabel.text = "Accuracy: " + String(format:"%.2f", accuracy) + "%"
        
        timeScoreLabel.isHidden = false
        scoreLabel.isHidden = false
        accuracyLabel.isHidden = false
        
        let newEntry = leaderboardEntry.init(time: time, score: Int(score), timestamp: 10, accuracy: accuracy)
        leaderboardEntries.append(newEntry)
//        for (index, entry) in leaderboardEntries.enumerated(){
//            if (entry == newEntry) {
//                leaderboardEntries.remove(at: index)
//            }
//        }
        print("HERE <--------------------------")
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGame" {
            if let dest = segue.destination as? ViewController {
                dest.delegate = self
            }
        }
        if segue.identifier == "toLeaderboard" {
            if let dest = segue.destination as? LeaderboardViewController {
                dest.entries = self.leaderboardEntries
                self.leaderboardEntries = []
            }
        }
    }
}
