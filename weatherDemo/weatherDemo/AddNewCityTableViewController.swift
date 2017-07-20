//
//  AddNewCityTableViewController.swift
//  weatherDemo
//
//  Created by wangyu on 20/07/2017.
//  Copyright © 2017 wangyu. All rights reserved.
//

import UIKit

class AddNewCityTableViewController: UITableViewController {

    var default_citys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        self.tableView.separatorStyle = .none
        
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        
        headView.backgroundColor = .black
        
        let search_tf = UITextField(frame: CGRect(x: 20, y: 15, width: self.view.frame.width-40, height: 30))
        
        search_tf.backgroundColor = .white
        
        search_tf.layer.cornerRadius = 15
        
        search_tf.layer.masksToBounds = true
        
        search_tf.leftView = UIImageView(image: UIImage(named: "search_b"))
        
        search_tf.leftViewMode = .always
        
        headView.addSubview(search_tf)
        
        search_tf.placeholder = "城市名称或拼音"
        
        self.tableView.tableHeaderView = headView

        let path = Bundle.main.path(forResource: "default-city", ofType: "plist")
        
        let array = NSArray(contentsOfFile: path!)
        
        for element in array!{
            
            self.default_citys.append(element as! String)
            
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
        return default_citys.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.backgroundColor = .black
        
        cell.textLabel?.textColor = .white
        
        // Configure the cell...
        if indexPath.row == 0 {
            
            cell.textLabel?.text = "自动定位"
            cell.imageView?.image = UIImage(named: "city")
            
        }else{
            
            cell.imageView?.image = nil
            cell.textLabel?.text = self.default_citys[indexPath.row - 1]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0
        {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AutoLocationNotification), object: nil)
            
        }else{
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: ChooseLocationNotification), object: nil, userInfo: ["choose_city":self.default_citys[indexPath.row - 1]])
            
        }
        
        self.dismiss(animated: true, completion: nil) 
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

    
    //MARK: - 隐藏状态栏
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
