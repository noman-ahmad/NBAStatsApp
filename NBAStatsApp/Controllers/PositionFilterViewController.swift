//
//  PositionFilterViewController.swift
//  NBAStatsApp
//
//  Created by Noman Ahmad on 5/15/21.
//

import UIKit

protocol FilterPositionDelegate {
    func addFilter(positions: [Bool])
}

class PositionFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate : FilterPositionDelegate?
    
    @IBAction func clickDone(_ sender: UIBarButtonItem) {
        var filters = [Bool]()
        filters.append(allPositions)
        filters.append(g)
        filters.append(g_f)
        filters.append(f)
        filters.append(f_c)
        filters.append(c)
        
        delegate?.addFilter(positions: filters)
        
        print(filters)
        self.navigationController?.popViewController(animated: true)    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    var allPositions = false
    var g = false
    var g_f = false
    var f = false
    var f_c = false
    var c = false
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "filteredCell")
        if indexPath.row == 0 {
            cell.textLabel?.text = "All Positions"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "G"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "G-F"
        } else if indexPath.row == 3 {
            cell.textLabel?.text = "F"
        } else if indexPath.row == 4 {
            cell.textLabel?.text = "F-C"
        } else {
            cell.textLabel?.text = "C"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let cell = tableView.cellForRow(at: indexPath) {
                if allPositions {
                    cell.accessoryType = .none
                    allPositions = false
                } else {
                    cell.accessoryType = .checkmark
                    allPositions = true
                }
            }
        } else if indexPath.row == 1 {
            if let cell = tableView.cellForRow(at: indexPath) {
                if g {
                    cell.accessoryType = .none
                    g = false
                } else {
                    cell.accessoryType = .checkmark
                    g = true
                }
            }
        } else if indexPath.row == 2 {
            if let cell = tableView.cellForRow(at: indexPath) {
                if g_f {
                    cell.accessoryType = .none
                    g_f = false
                } else {
                    cell.accessoryType = .checkmark
                    g_f = true
                }
            }
        } else if indexPath.row == 3 {
            if let cell = tableView.cellForRow(at: indexPath) {
                if f {
                    cell.accessoryType = .none
                    f = false
                } else {
                    cell.accessoryType = .checkmark
                    f = true
                }
            }
        } else if indexPath.row == 4 {
            if let cell = tableView.cellForRow(at: indexPath) {
                if f_c {
                    cell.accessoryType = .none
                    f = false
                } else {
                    cell.accessoryType = .checkmark
                    f_c = true
                }
            }
        } else if indexPath.row == 5 {
            if let cell = tableView.cellForRow(at: indexPath) {
                if c {
                    cell.accessoryType = .none
                    c = false
                } else {
                    cell.accessoryType = .checkmark
                    c = true
                }
            }
        }
    }
    
    func tableView(tableView: UITableView,heightForFooterInSection section: Int) -> CGFloat {
         return 1
    }
    

    @IBOutlet weak var filterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filterTableView.delegate = self
        self.filterTableView.dataSource = self
        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        let colors_on = defaults.bool(forKey: "dark_mode")
        if colors_on{
            overrideUserInterfaceStyle = .dark
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.barTintColor = .black
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        } else {
            overrideUserInterfaceStyle = .light
            navigationController?.navigationBar.tintColor = .black
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
        
        self.navigationItem.title = "Filter by Position"

    }
    

}
