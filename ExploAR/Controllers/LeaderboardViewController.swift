//
//  LeaderboardViewController.swift
//  ExploAR
//
//  Created by Nicholas Compton on 4/19/22.
//

import UIKit
import ARKit

extension Date {
    struct Formatter {
        static let short: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    }
    var short: String {
        return Formatter.short.string(from: self)
    }
}


class LeaderboardViewController: UITableViewController {

    var entries : [leaderboardEntry] = []
    @IBOutlet var bable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MAIN_COLOR_BG
        
        let defaults = UserDefaults.standard
        
        if (defaults.object(forKey: "ShooterLeaderboard") == nil) {
            return
        }
        
        let history: [[String: Any]] = defaults.object(forKey: "ShooterLeaderboard") as! [[String : Any]]
        for item in history {
            self.entries.append(leaderboardEntry(time: item["time"] as! Double, score: item["score"] as! Int, timestamp: item["timestamp"] as! Int, accuracy: item["accuracy"] as! Double))
        }
        
        entries.sort {$0.score > $1.score}
    }
    
    @IBAction func clearLeaderboard(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "ShooterLeaderboard")
        self.entries = []
        bable.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        var converted: [[String: Any]] = []
        for item in self.entries {
            converted.append(item.toDict())
        }
        defaults.set(converted, forKey: "ShooterLeaderboard")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
        let leaderboardItem = self.entries[indexPath.row]
        cell.indexLabel.text = "# \(indexPath.row + 1)"
        cell.timeLabel.text = "Time: \(String(format:"%.2f", leaderboardItem.time))"
        cell.scoreLabel.text = "Score: \(String(Int(leaderboardItem.score)))"
        cell.accuracyLabel.text = "Acc: \(String(format:"%.2f", leaderboardItem.accuracy))"
        return cell
    }
}

class LeaderboardCell: UITableViewCell {
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
}


