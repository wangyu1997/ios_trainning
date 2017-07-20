//
//  Tool.swift
//  weatherDemo
//
//  Created by wangyu on 19/07/2017.
//  Copyright © 2017 wangyu. All rights reserved.
//

import UIKit

class Tool {
    class func returnDate(date:Date)->String {
        let dateFormat = DateFormatter()
        
        dateFormat.locale = Locale(identifier: "ch")
        dateFormat.dateFormat = "MM.dd"
        
        return dateFormat.string(from:date)
    }
    
    enum WeekDays:String {
        case Monday = "周一"
        case Tuesday = "周二"
        case Wednesday = "周三"
        case Thursday = "周四"
        case Friday = "周五"
        case Saturday = "周六"
        case Sunday = "周日"
    }
    
    class func returnWeekDay(date:Date)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ch")
        dateFormatter.dateFormat = "EEEE"
        let dateStr = dateFormatter.string(from: date)
        switch dateStr {
            case "Monday":
                return WeekDays.Monday.rawValue
            case "Tuesday":
                return WeekDays.Tuesday.rawValue
            case "Wednesday":
                return WeekDays.Wednesday.rawValue
            case "Thursday":
                return WeekDays.Thursday.rawValue
            case "Friday":
                return WeekDays.Friday.rawValue
            case "Saturday":
                return WeekDays.Saturday.rawValue
            default:
                return WeekDays.Sunday.rawValue
        }
        
    }
    
    class func colorWithHexString(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if cString.characters.count != 6
        {
            return .gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)

        var r:CUnsignedInt = 0,g:CUnsignedInt = 0,b:CUnsignedInt = 0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
    
    
    class func returnWeatherBGColor(weatherType:String)->UIColor
    {
        let weatherTypePath = Bundle.main.path(forResource: "weatherBG", ofType: "plist")
        
        if weatherTypePath != nil
        {
            let json = NSDictionary(contentsOfFile: weatherTypePath!)
            
            for element in (json?.allKeys)!
            {
                if element as! String == weatherType || weatherType.hasPrefix(element as! String)                {
                    let key = element as! String
                    let value = json![key] as! String
                    return Tool.colorWithHexString(hex:value)
                }
            }
        }
        
        return .gray
    }
    
    class func returnNeedDay(getDateString:String)->String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ch")
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.date(from: getDateString)
        
        let newFormatter = DateFormatter()
        newFormatter.locale = Locale(identifier: "ch")
        
        let dateStr = newFormatter.string(from: date!)
        
        return dateStr
    }
    
    class func returnWeekDay(getWeekDayString:String)->String {
        if getWeekDayString == "星期一" {
            return "周一"
        }else if getWeekDayString == "星期二" {
            return "周二"
        }else if getWeekDayString == "星期三" {
            return "周三"
        }else if getWeekDayString == "星期四" {
            return "周四"
        }else if getWeekDayString == "星期五" {
            return "周五"
        }else if getWeekDayString == "星期六" {
            return "周六"
        }else {
            return "周日"
        }
    }
    
    class func returnWeatherType(weatherType:String)->String
    {
        let weatherTypePath = Bundle.main.path(forResource: "weatherBG", ofType: "plist")
        
        if weatherTypePath != nil
        {
            let json = NSDictionary(contentsOfFile: weatherTypePath!)
            
            for element in (json?.allKeys)!
            {
                if weatherType.hasPrefix(element as! String)                {
                    return element as! String
                }
            }
        }
        
        return weatherType
    }
    
    class func returnWeatherImage(weatherType:String)->UIImage?
    {
        let weatherTypePath = Bundle.main.path(forResource: "weatherImage", ofType: "plist")
        
        if weatherTypePath != nil
        {
            let json = NSDictionary(contentsOfFile: weatherTypePath!)
            
            for element in (json?.allKeys)!
            {
                if weatherType.hasPrefix(element as! String) {
                   
                    let value = json![element as! String] as! String
                    
                    return UIImage(named: value)
                }
            }
        }
        
        return nil
    }
    
    
    class func returnWeatherMessage(weatherType:String)->UIImage?
    {
        let weatherTypePath = Bundle.main.path(forResource: "weatherMessage", ofType: "plist")
        
        if weatherTypePath != nil
        {
            let json = NSDictionary(contentsOfFile: weatherTypePath!)
            
            for element in (json?.allKeys)!
            {
                if weatherType.hasPrefix(element as! String) {
                    
                    let value = json![element as! String] as! String
                    
                    return UIImage(named: value)
                }
            }
        }
        
        return nil
    }
    
    class func getImageFromView(view:UIView) -> UIImage{
        
        UIGraphicsBeginImageContext(view.bounds.size)
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
        
    }
}
