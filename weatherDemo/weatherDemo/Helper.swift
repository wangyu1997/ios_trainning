//
//  Helper.swift
//  weatherDemo
//
//  Created by wangyu on 19/07/2017.
//  Copyright © 2017 wangyu. All rights reserved.
//

import UIKit


let leftControllerAndRightControllerBGColor =
    UIColor(red: CGFloat(40.0/255.0), green: CGFloat(37.0/255.0), blue: CGFloat(40.0/255.0), alpha: 1.0)



let LeftControllerTypeChangedNotification = "LeftControllerTypeChangedNotification"

let AutoLocationNotification = "AutoLocationNotification"

let ChooseLocationNotification = "ChooseLocationNotification"

let DeleteHistoryCityNotification = "DeleteHistoryCityNotification"


let history_city_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]+"/" + "history_city_path"


//shareSDK

let ShareSDK_AppKey = "1f9189eae884a"

//sina
let Sina_AppKey = "889979272"

let Sina_AppSecret = "9e41cfa1b055808631ed903660607e46"

let Sina_OAuth_Html = "http://www.baidu.com"

//QQ
let QQ_AppID = "1106225715"

let QQ_AppKey = "Ofiwl6wHDWMyYeGJ"

//wechat
let weixin_AppID = "wx8571a4f11404252a"
let weixin_AppSecret = "129663c38c2a9302ec7ba3b608a245c8"



class Helper: NSObject {
    
    class func readChaceCity()->[String] {
        
        let array = NSArray(contentsOfFile: history_city_path)
        
        if array == nil {
            return []
        }else if array?.count == 0 {
            return []
        }else{
            var citys = [String]()
            
            for element in array! {
                citys.append(element as! String)
            }
            
            return citys
        }
        
    }
    
    
    class func insertCity(city:String)-> Bool {
        
        var old_citys = Helper.readChaceCity()
        
        if old_citys.contains(city) {
            
            old_citys.remove(at: old_citys.index(of: city)!)
            
        }
        
        old_citys.insert(city, at: 0)
        
        let array = NSMutableArray()
        
        for element in old_citys {
            
            array.add(element)
            
        }
        
        return array.write(toFile: history_city_path, atomically: true)
        
    }
    
    class func deleteCity(city:String)-> Bool {
        
        var old_citys = Helper.readChaceCity()
        
        if old_citys.contains(city) {
            
            old_citys.remove(at: old_citys.index(of: city)!)
            
        }
                
        let array = NSMutableArray()
        
        for element in old_citys {
            
            array.add(element)
            
        }
        
        return array.write(toFile: history_city_path, atomically: true)
        
    }
    
    
}
