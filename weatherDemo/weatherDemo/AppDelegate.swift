//
//  AppDelegate.swift
//  weatherDemo
//
//  Created by wangyu on 18/07/2017.
//  Copyright © 2017 wangyu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        /**
         *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
         *  在将生成的AppKey传入到此方法中。
         *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
         *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
         *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
         */

        ShareSDK.registerActivePlatforms([SSDKPlatformType.typeSinaWeibo.rawValue,SSDKPlatformType.typeWechat.rawValue,SSDKPlatformType.typeQQ.rawValue], onImport: {
            
            platform in
            
            switch platform {
            case .typeQQ :
                ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                break
            case .typeWechat:
                ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                break
            case .typeSinaWeibo:
                ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                break
            default:
                break
            }
        }, onConfiguration: {
            (platform ,appInfo:NSMutableDictionary!) in
            
            switch platform {
            case .typeQQ:
                appInfo.ssdkSetupQQ(byAppId: QQ_AppID, appKey: QQ_AppKey, authType: SSDKAuthTypeBoth)
                
            case .typeSinaWeibo:
                appInfo.ssdkSetupSinaWeibo(byAppKey: Sina_AppKey, appSecret: Sina_AppSecret, redirectUri: Sina_OAuth_Html, authType: SSDKAuthTypeBoth)
            case .typeWechat:
                appInfo.ssdkSetupWeChat(byAppId: weixin_AppID, appSecret: weixin_AppSecret)
            default:
                break
            }
            
        })
        

//       2 适配iOS 9白名单
        
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        let leftVC = LeftTableViewController()
        let rightVC = RightTableViewController()
        
        window?.rootViewController = DrawerViewController(mainVC: mainVC as! UINavigationController, leftVC: leftVC, rightVC: rightVC)
        window?.makeKeyAndVisible()
        
//      MARK: - 配置导航控制器
        UINavigationBar.appearance().setBackgroundImage(UIImage(),for: .any, barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

