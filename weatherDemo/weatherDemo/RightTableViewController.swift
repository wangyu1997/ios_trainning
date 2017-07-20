//
//  RightTableViewController.swift
//  weatherDemo
//
//  Created by wangyu on 18/07/2017.
//  Copyright © 2017 wangyu. All rights reserved.
//

import UIKit

class RightTableViewController: UITableViewController {

    //需要本地存储
    var historyCity = Helper.readChaceCity()
    
    let section0Title = ["提醒","设置","支持"]
    let section0Img = ["reminder","setting_right","contact"]

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = leftControllerAndRightControllerBGColor
        
        
        let nib = UINib(nibName: "RightTableViewCell", bundle:Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: "reuseIdentifier")
        
        self.tableView.rowHeight = 70
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: NSNotification.Name(rawValue: AutoLocationNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: NSNotification.Name(rawValue: ChooseLocationNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: NSNotification.Name(rawValue: DeleteHistoryCityNotification), object: nil)
        
    }
    
    func reloadTableView(_ sender:Notification){
        self.historyCity = Helper.readChaceCity()
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 3
        }else{
            return 2 + historyCity.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! RightTableViewCell

        // Configure the cell...
        
        cell.controller = self

        if indexPath.section == 0 {
            
            cell.titleLabel.text = section0Title[indexPath.row]
            cell.indicatorImageView.image = UIImage(named: section0Img[indexPath.row])
            cell.deleteImageView.isHidden = true
            
        }else{
            
            if indexPath.row == 0 {
                cell.titleLabel.text = "添加"
                cell.indicatorImageView.image = UIImage(named: "addcity")
                cell.deleteImageView.isHidden = true
            }
            else if indexPath.row == 1 {
                cell.titleLabel.text = "定位"
                cell.indicatorImageView.image = UIImage(named: "city")
                cell.deleteImageView.isHidden = true
            }
            else{
                cell.titleLabel.text = historyCity[indexPath.row-2]
                cell.indicatorImageView.image = UIImage(named: "city")
            }
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 30
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
            return label
        }else{
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
            label.text = "城市管理"
            label.textAlignment = .center
            label.backgroundColor = .black
            label.textColor = .white
            return label
        }
        
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let storyBorad = UIStoryboard(name: "Main", bundle: Bundle.main)
                
                let addNewCityController = storyBorad.instantiateViewController(withIdentifier: "AddNewCityTableViewController") as! AddNewCityTableViewController
                
                DrawerViewController.drawerVC.present(addNewCityController, animated: true, completion: {
                
                })
                
            }else if indexPath.row == 1{
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: AutoLocationNotification), object: nil)
                
            }else{
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: ChooseLocationNotification), object: nil, userInfo: ["choose_city":self.historyCity[indexPath.row - 2]])
                
            }
            
        }
        
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
