//
//  NextGameTableViewCell.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 5/9/21.
//

import UIKit

class NextGameTableViewCell: UITableViewCell {
    @IBOutlet weak var awayImage: UIImageView!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var playoffsImage: UIImageView!
    @IBOutlet weak var awayName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureNextGame(forGame: GameInfo){
        
        print("Here I am")
        print(forGame.id)
        print(forGame.date)
        print(forGame.home_team)
        print(forGame.visitor_team)
        
        if forGame.home_team?.abbreviation == "" {
            awayName.text = ""
            homeName.text = ""
            date.text = "Next Game TBA"
        } else {
        
            awayName.text = forGame.visitor_team?.abbreviation
            homeName.text = forGame.home_team?.abbreviation
            let hteamurl = "http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/" + "\((forGame.home_team!.abbreviation).lowercased())" + ".png"
            let hurl = URL(string: hteamurl)
            homeImage.load2(url: hurl!, placeholder: nil)
            
            let ateamurl = "http://i.cdn.turner.com/nba/nba/.element/img/1.0/teamsites/logos/teamlogos_500x500/" + "\((forGame.visitor_team!.abbreviation).lowercased())" + ".png"
            let aurl = URL(string: ateamurl)
            awayImage.load2(url: aurl!, placeholder: nil)
            
            let start_date = forGame.date!.index(forGame.date!.startIndex, offsetBy: 5)
            let end_date = forGame.date!.index(forGame.date!.startIndex, offsetBy: 9)
                let range = start_date...end_date
                let formatted_date = String(forGame.date![range])
            let newString = formatted_date.replacingOccurrences(of: "-", with: "/", options: .literal, range: nil)
            
            date.text = newString
        }
        if forGame.postseason == true {
            playoffsImage.image = #imageLiteral(resourceName: "4741__nba_playoffs-primary_on_dark-2018")
            //playoffsImage.backgroundColor = .black
        } 
    }

}
