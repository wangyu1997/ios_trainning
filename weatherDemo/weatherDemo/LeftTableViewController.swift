//
//  LeftTableViewController.swift
//  weatherDemo
//
//  Created by wangyu on 18/07/2017.
//  Copyright © 2017 wangyu. All rights reserved.
//

import UIKit

class LeftTableViewController: UITableViewController {

    var dataSource = [WeatherInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = leftControllerAndRightControllerBGColor
        
        let nib = UINib(nibName: "LeftTableViewCell", bundle:Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: "reuseIdentifier")

        self.tableView.rowHeight = 100
        
        self.tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData(_:)), name: NSNotification.Name(rawValue: LeftControllerTypeChangedNotification), object: nil)
    }
    
    func refreshData(_ sender: Notification) {
        let info = sender.userInfo!["data"] as! NSArray
        
        if self.dataSource.count > 0
        {
            self.dataSource.removeAll()
        }
        
        for element in info {
            let dic = element as! NSDictionary
            let weather = WeatherInfo(dic: dic)
            self.dataSource.append(weather)
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! LeftTableViewCell

        let dayWeatherInfo = self.dataSource[indexPath.row]
        
        cell.dateLabel.text = Tool.returnNeedDay(getDateString: dayWeatherInfo.days!) 
        cell.weekDayLabel.text = Tool.returnWeekDay(getWeekDayString: dayWeatherInfo.week!)
        cell.temperatureLabel.text = dayWeatherInfo.temp_low! + "~" + dayWeatherInfo.temp_high!
        cell.weatherLabel.text = Tool.returnWeatherType(weatherType:dayWeatherInfo.weather!)
        cell.weatherBgView.backgroundColor = Tool.returnWeatherBGColor(weatherType: dayWeatherInfo.weather!)
        // Configure the cell...
        if indexPath.row == 0{
            cell.weekDayLabel.text = "今天"
        }
        if indexPath.row == 1{
            cell.weekDayLabel.text = "明天"
        }

        return cell
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
