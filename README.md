NBA Stats App 

Overview: An iOS Mobile Application to see stats, games, and players for the NBA (National Basketball Association) for the 2020-21 Season 

Prerequisites: 
- A Macbook Computer/Laptop (Higher specs the better) 
- The Latest Version of XCode  
- iPhone SE (2nd Gen) or better
- iOS 13.0+ (if building directly to your device) 

Building Instrutions: 
- Download and Extract the zip to your local machine 
- open up NBAStatsApp.xcodeproj using xcode 
- Choose your device, or select a simulator 
- click build and run (the large play button) 
- Use the App! 

Compatability: 
- Devices Fully Working: any iPhone SE or better with iOS 13.0 
- Devices Not Working Properly: iPod Touch, iPad Devices 

Current Issues (v1.04):  
- Player Images Missing for Some Players (Most are now updated)  
- Delay between view usage (API Limitation, currently the only workaround is to have delays) 
- Team Images low res on Initial Team Selection View 
- API Call Limit still occurs occasionally 
- Contraint Problems with Auto-Layout on Stats View 
- Defaults to brute-force filtering of current players

Future Features (may or may not be implemented): 
- Dark Mode based on user device settings 
- Standings & Playoffs Tree 
- Overall Stats Leaders 
- User Favourited Teams & Players 

Framework & Technologies Used: 
- Front End: Swift + UIKit (Using XCode) 
- Back End: balldontlie api (www.balldontlie.io), nba-api-client (https://github.com/bttmly/nba-client-template/blob/master/nba.json)
- Other Frameworks: Kingfisher (for web image loading and caching -> https://github.com/onevcat/Kingfisher) 

Built by Noman Ahmad









