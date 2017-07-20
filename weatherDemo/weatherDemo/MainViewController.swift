//
//  MainViewController.swift
//  weatherDemo
//
//  Created by wangyu on 18/07/2017.
//  Copyright © 2017 wangyu. All rights reserved.
//

import UIKit
import CoreLocation

import MBProgressHUD

class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    var imageView:UIImageView!
    
    var myTableView: UITableView!
    
    let header = MJRefreshNormalHeader()
    
    var cur_weather_info:NSDictionary?
    
//    拿到位置的经纬度
    var locationManager:CLLocationManager!
    
//    根据经纬度解析成地名
    let geocoder:CLGeocoder! = CLGeocoder()
    
    var current_city:String!
    
    var hub:MBProgressHUD!
    
    let Current_City_Key = "Current_City_Key"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .black
        
        let theCity = UserDefaults.standard.value(forKey: Current_City_Key)
        
        //      定位之前 动画
        self.hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        if theCity == nil {
            
            self.hub.label.text = "正在定位..."
            self.location()
            
        }else{
            
            current_city = theCity as! String
            initView()
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(autoLocationAction(_:)), name: NSNotification.Name(rawValue: AutoLocationNotification), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(chooseLocationAction(_:)), name: NSNotification.Name(rawValue: ChooseLocationNotification), object: nil)
        
    }
    
    func initView(){
        self.layoutNavigationBar(date: Tool.returnDate(date: Date()), weekDay: Tool.returnWeekDay(date: Date()), cityName: current_city)
        
        self.request(cityName: current_city)
        
        if self.myTableView == nil {
            
            self.automaticallyAdjustsScrollViewInsets = false
            
            myTableView = UITableView(frame: CGRect(x: 0, y: 44, width: self.view.frame.size.width, height:self.view.frame.size.height), style: .plain)
            
            self.view.addSubview(myTableView)
            
            //      MARK: - 如何使用MJRefresh
            self.myTableView.mj_header = header
            
            header.refreshingBlock = {
                
                self.layoutNavigationBar(date: Tool.returnDate(date: Date()), weekDay: Tool.returnWeekDay(date: Date()), cityName: self.current_city)
                self.request(cityName: self.current_city)
                
            }
            let nib = UINib(nibName: "MainTableViewCell", bundle:Bundle.main)
            self.myTableView.register(nib, forCellReuseIdentifier: "reuseIdentifier")
            
            
            self.myTableView.rowHeight = 720
            
            self.myTableView.isHidden = true
            self.myTableView.separatorStyle = .none
            
            self.myTableView.dataSource = self
            self.myTableView.delegate = self
            
        }
    }
    
    func layoutNavigationBar(date:String,weekDay:String,cityName:String) {
        
        self.navigationController?.navigationBar.tintColor = .white
        
        let categoryBarItem = UIBarButtonItem(image: UIImage(named:"category_hover"), style: .plain, target: self, action:#selector(chooseDateAction(_:)) )
        
        categoryBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        
        let dateBarItem = UIBarButtonItem(title: date+"/"+weekDay, style: .plain, target: self, action: #selector(chooseDateAction(_:)))
        
        self.navigationItem.leftBarButtonItems = [categoryBarItem,dateBarItem ]
        
        
        let shareBarItem = UIBarButtonItem(image: UIImage(named:"share_small_hover"), style: .plain, target: self, action:#selector(shareAction(_:)) )
        
        let cityBarItem = UIBarButtonItem(title: cityName, style: .plain, target: nil, action: nil)
        
//        cityBarItem.isEnabled = false
        
        let settingBarItem = UIBarButtonItem(image: UIImage(named:"settings_hover"), style: .plain, target: self, action:#selector(settingAction(_:)) )
        
        self.navigationItem.rightBarButtonItems = [settingBarItem,cityBarItem,shareBarItem]

    }
    
    func autoLocationAction(_ sender: Notification) {
        self.location()
    }
    
    func chooseLocationAction(_ sender: Notification) {
        self.current_city = sender.userInfo!["choose_city"] as! String
        
        Helper.insertCity(city: self.current_city)
        
        self.initView()
    }
    
    
    func chooseDateAction(_ sender:UIBarButtonItem) {
        
    }
    
    
    func shareAction(_ sender:UIBarButtonItem) {
        
        let actionSheet = UIAlertController(title: "分享天气", message: "", preferredStyle: .actionSheet)
        
        let sinaAction = UIAlertAction(title: "分享到新浪微博", style: .default, handler: {
            action in
            
            let mDic = NSMutableDictionary()
            
            mDic.ssdkSetupSinaWeiboShareParams(byText: "测试", title: "麦子天气" , image: Tool.getImageFromView(view: (self.navigationController?.view)!)  , url: nil, latitude: 0, longitude: 0, objectID: nil, type: .auto)
            
            
            ShareSDK.share(.typeSinaWeibo, parameters: mDic, onStateChanged: {
                (state, userData, contentEntity, error) in
                
                
                switch state{
                    
                case .success: print("分享成功")
                case .fail:    print("授权失败,错误描述:\(error.debugDescription)")
                case .cancel:  print("操作取消")
                    
                default:
                    break
                }
                
            })
            
        })
        
        let QQFriendAction = UIAlertAction(title: "分享到QQ好友", style: .default, handler: {
            action in
            
            let mDic = NSMutableDictionary()
            
            mDic.ssdkSetupQQParams(byText: "测试", title: "麦子天气", url: nil, thumbImage: Tool.getImageFromView(view: (self.navigationController?.view)!), image: Tool.getImageFromView(view: (self.navigationController?.view)!), type: .auto , forPlatformSubType: .subTypeQQFriend)
            
            ShareSDK.share(.subTypeQQFriend, parameters: mDic, onStateChanged: {
                (state, userData, contentEntity, error) in
                
                
                switch state{
                    
                case .success: print("分享成功")
                case .fail:    print("授权失败,错误描述:\(error.debugDescription)")
                case .cancel:  print("操作取消")
                    
                default:
                    break
                }
                
            })

            
            
        })
        
        
        let QQZoneAction = UIAlertAction(title: "分享到QQ空间", style: .default, handler: {
            action in
            
            let mDic = NSMutableDictionary()

            mDic.ssdkSetupQQParams(byText: "测试", title: "麦子天气", url: URL(string: "http://www.baidu.com"), thumbImage: Tool.getImageFromView(view: (self.navigationController?.view)!), image: Tool.getImageFromView(view: (self.navigationController?.view)!), type: .auto , forPlatformSubType: .subTypeQZone)
            
            ShareSDK.share(.subTypeQZone, parameters: mDic, onStateChanged: {
                (state, userData, contentEntity, error) in
                
                
                switch state{
                    
                case .success: print("分享成功")
                case .fail:    print("授权失败,错误描述:\(error.debugDescription)")
                case .cancel:  print("操作取消")
                    
                default:
                    break
                }
                
            })
            
            
        })
        
        let wechatFriendction = UIAlertAction(title: "分享到微信好友", style: .default, handler: {
            action in
            
            
            let mDic = NSMutableDictionary()
            
            mDic.ssdkSetupWeChatParams(byText: "测试", title: "测试", url: nil, thumbImage:  UIImage(named:"Default"), image:  UIImage(named:"Default"), musicFileURL: nil, extInfo: nil, fileData: UIImagePNGRepresentation(Tool.getImageFromView(view: (self.navigationController?.view)!)), emoticonData: nil, sourceFileExtension: "png", sourceFileData: UIImagePNGRepresentation(Tool.getImageFromView(view: (self.navigationController?.view)!)), type: .auto, forPlatformSubType: .subTypeWechatSession)
            
            ShareSDK.share(.subTypeWechatSession , parameters: mDic, onStateChanged: {
                (state, userData, contentEntity, error) in
                
                
                switch state{
                    
                case .success: print("分享成功")
                case .fail:    print("授权失败,错误描述:\(error.debugDescription)")
                case .cancel:  print("操作取消")
                    
                default:
                    break
                }
                
            })
            
            
        })
        
        let wechatCircleAction = UIAlertAction(title: "分享到微信朋友圈", style: .default, handler: {
            action in
            
            let mDic = NSMutableDictionary()
            
            mDic.ssdkSetupWeChatParams(byText: "测试", title: "测试", url: nil, thumbImage:  Tool.getImageFromView(view: (self.navigationController?.view)!), image:  Tool.getImageFromView(view: (self.navigationController?.view)!), musicFileURL: nil, extInfo: nil, fileData: UIImagePNGRepresentation(Tool.getImageFromView(view: (self.navigationController?.view)!)), emoticonData: nil, sourceFileExtension: "png", sourceFileData: UIImagePNGRepresentation(Tool.getImageFromView(view: (self.navigationController?.view)!)), type: .auto, forPlatformSubType: .subTypeWechatTimeline)
            
            ShareSDK.share(.subTypeWechatTimeline , parameters: mDic, onStateChanged: {
                (state, userData, contentEntity, error) in
                
                
                switch state{
                    
                case .success: print("分享成功")
                case .fail:    print("授权失败,错误描述:\(error.debugDescription)")
                case .cancel:  print("操作取消")
                    
                default:
                    break
                }
                
            })
            

            
        })
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {
            action in
            
            
        })
        
        actionSheet.addAction(sinaAction)
        actionSheet.addAction(QQFriendAction)
        actionSheet.addAction(QQZoneAction)
        actionSheet.addAction(wechatFriendction)
        actionSheet.addAction(wechatCircleAction)
        actionSheet.addAction(cancelAction)
        
        DrawerViewController.drawerVC.present(actionSheet, animated: true, completion: {
        
        })
        
    }
    
    func settingAction(_ sender:UIBarButtonItem) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as! MainTableViewCell
        
        if self.cur_weather_info != nil{
            //需要构建逻辑代码来显示不同的图片
//            cell.messageImageView.image =
            let weather = self.cur_weather_info!["weather"] as! String
            
            cell.weatherImageView.image = Tool.returnWeatherImage(weatherType: weather)
            
            cell.weatherLabel.text = weather
            
            
            let temp_curr = self.cur_weather_info!["temp_curr"] as! String
            
            let temp_low = self.cur_weather_info!["temp_low"] as! String

            let temp_high = self.cur_weather_info!["temp_high"] as! String

            
            cell.current_temp_label.text = temp_curr
            
            cell.range_temp_label.text = temp_low + "~" + temp_high
            
            cell.windLabel.text = self.cur_weather_info!["wind"] as? String
            
            
            cell.range_humidity_label.text = self.cur_weather_info!["humidity"] as? String
            
            cell.messageImageView.image = Tool.returnWeatherMessage(weatherType: weather)

            
        }
        
        
        return cell
    }
    
    
    func location()
    {
        //        判断用户定位是否打开
        if CLLocationManager.locationServicesEnabled() {
            
            self.locationManager = CLLocationManager()
            
            //            iOS8 之后的定位需要用户授权
            if ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 8, minorVersion: 0, patchVersion: 0)){
                
                self.locationManager.requestAlwaysAuthorization()
                
            }
            
            self.locationManager.startUpdatingLocation()
            
            self.locationManager.delegate = self
        }
    }
    
    //    定位失败
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("error\(error.localizedDescription)")
        
    }
    
    //    定位成功
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            
            
            //            停止定位
            locationManager.stopUpdatingLocation()
            
            let locationsInfo = locations.last
            
            geocoder.reverseGeocodeLocation(locationsInfo!, completionHandler: { (placeMarks, error) in
                
                if (placeMarks?.count)! > 0 {
                    
                    let placeM = placeMarks![0]
                    
                    self.current_city = placeM.locality
                    
                    
                    DispatchQueue.main.async {
                        
                        if self.current_city.contains("市")
                        {
                            let range = self.current_city.range(of: "市")
                            self.current_city.removeSubrange(range!)
                            
                        }
                        
                        self.hub.label.text = "定位成功,正在读取天气信息..."
                        
                        Helper.insertCity(city: self.current_city)
                        
                        //                            保存城市
                        UserDefaults.standard.set(self.current_city, forKey: self.Current_City_Key)
                        
                        self.initView()
                    }
                }
                
            })
            
        }
        
    }

    
    func request(cityName:String) {
        
//      MARK: - json
//      请求七天的天气情况
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 180, width: 100, height: 100))
        
        self.view.addSubview(imageView)
        
        let urlString = "http://api.k780.com:88/?app=weather.future&weaid=\(cityName)&&appkey=26148&sign=0d2d0cbdef9731027e4e17d63957b95f&format=json".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: urlString!)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!){
            (data,response,error) in
                guard let data = data, let weatherInfo = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary else{
                        return
            }
            
            let array = weatherInfo["result"] as! NSArray
            
            DispatchQueue.main.async {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LeftControllerTypeChangedNotification), object: nil, userInfo: ["data":array])
            }
        }
        
        task.resume()
        
        //MARK: - 请求当天的天气信息
//      请求当天的天气情况
        let cur_urlString = "http://api.k780.com:88/?app=weather.today&weaid=\(cityName)&&appkey=26148&sign=0d2d0cbdef9731027e4e17d63957b95f&format=json".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let cur_url = URL(string: cur_urlString!)
        
        let cur_task = URLSession.shared.dataTask(with: cur_url!){
            (data,response,error) in
            guard let data = data, let weatherInfo = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary else{
                return
            }
            
            let dic = weatherInfo["result"] as! NSDictionary
            
            self.cur_weather_info = dic
            
            
            DispatchQueue.main.async {
                
                let cur_weather_msg = self.cur_weather_info!["weather"] as! String
                
                self.view.backgroundColor = Tool.returnWeatherBGColor(weatherType: cur_weather_msg)
                
                self.myTableView.backgroundColor = Tool.returnWeatherBGColor(weatherType: cur_weather_msg)
                
                self.navigationController?.navigationBar.backgroundColor = Tool.returnWeatherBGColor(weatherType: cur_weather_msg)
                
                let cell = self.myTableView.cellForRow(at: IndexPath(row: 0, section: 0))
                
                cell?.backgroundColor = Tool.returnWeatherBGColor(weatherType: cur_weather_msg)
                
                self.myTableView.isHidden = false

                self.header.endRefreshing()

                self.myTableView.reloadData()
                
                self.hub.isHidden = true
    
            }
            
        }
        
        cur_task.resume()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
