//
//  DrawerViewController.swift
//  weatherDemo
//
//  Created by wangyu on 18/07/2017.
//  Copyright © 2017 wangyu. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {
    
    var mainVC:UIViewController?
    var leftVC:LeftTableViewController?
    var rightVC:RightTableViewController?
    
    var mainSpacing:CGFloat?
    var mainWidth:CGFloat?
    var sideWidth:CGFloat?
    
    //单例
    static let drawerVC = UIApplication.shared.keyWindow?.rootViewController as! DrawerViewController
    
    
    init(mainVC:UINavigationController,leftVC:LeftTableViewController,rightVC:RightTableViewController) {
        super.init(nibName: nil, bundle: nil)
    
        mainSpacing = 60
        mainWidth = UIScreen.main.bounds.width
        sideWidth = mainWidth!-mainSpacing!

        
        self.mainVC = mainVC
        self.leftVC = leftVC
        self.rightVC = rightVC
    
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        self.view.addSubview((leftVC?.view)!)
        self.view.addSubview((rightVC?.view)!)
        self.view.addSubview((mainVC?.view)!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showMainViewAction(_:)), name: NSNotification.Name(rawValue: AutoLocationNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showMainViewAction(_:)), name: NSNotification.Name(rawValue: ChooseLocationNotification), object: nil)
        
                
        leftVC?.view.transform = CGAffineTransform(translationX: -sideWidth!/2, y: 0)
        rightVC?.view.transform = CGAffineTransform(translationX: sideWidth!/2, y: 0)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))

        mainVC?.view.addGestureRecognizer(pan)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - 打开左边侧滑
    func openLeft() {
        UIView.animate(withDuration: 0.25, animations: {
            self.leftVC?.view.transform = CGAffineTransform.identity
            self.mainVC?.view.transform = CGAffineTransform(translationX: self.sideWidth!, y: 0)
            self.leftVC?.view.isHidden = false
            self.rightVC?.view.isHidden = true
        }){
            finish in
            self.mainVC?.view.addSubview(self.coverBtn)
        }
    }
    
    //MARK: - 关闭左边侧滑
    func closeLeft() {
        UIView.animate(withDuration: 0.25, animations: {
            self.leftVC?.view.transform = CGAffineTransform(translationX: -self.sideWidth!/2, y: 0)
            self.mainVC?.view.transform = CGAffineTransform.identity
        }){
            finish in
            self.coverBtn.removeFromSuperview()
            self.leftVC?.view.isHidden = false
            self.rightVC?.view.isHidden = false
        }
    }
    
    //MARK: - 关闭右边侧滑
    func closeRight() {
        UIView.animate(withDuration: 0.25, animations: {
            self.rightVC?.view.transform = CGAffineTransform(translationX: self.sideWidth!/2, y: 0)

            self.mainVC?.view.transform = CGAffineTransform.identity
        }){
            finish in
            self.coverBtn.removeFromSuperview()
        }
    }
    
    
    //MARK: - 打开右边侧滑
    func openRight() {
        UIView.animate(withDuration: 0.25, animations: {
            self.rightVC?.view.transform = CGAffineTransform.identity
            self.mainVC?.view.transform = CGAffineTransform(translationX: -self.sideWidth!, y: 0)
        }){
            finish in
            self.mainVC?.view.addSubview(self.coverBtn)
        }
    }
    
    //MARK: - 关闭侧滑
    func closeSide() {
        if (mainVC?.view.frame.origin.x)!>CGFloat(0) {
            closeLeft()
        }else if (mainVC?.view.frame.origin.x)!<CGFloat(0){
            closeRight()
        }
    }
    
    
    //MARK: - 主界面侧滑手势
    func panAction(_ pan:UIPanGestureRecognizer) {
        let offsetX = pan.translation(in: pan.view).x
        
        if offsetX>0 {
            //向右滑动
            if pan.state == .changed && offsetX <= self.sideWidth! {
                mainVC?.view.transform = CGAffineTransform(translationX: offsetX, y: 0)
                leftVC?.view.transform = CGAffineTransform(translationX: (offsetX-self.sideWidth!)/2, y: 0)
                self.leftVC?.view.isHidden = false
                self.rightVC?.view.isHidden = true
            }else if pan.state == .cancelled || pan.state == .ended || pan.state == .failed{
                if offsetX>=sideWidth!/3 {
                    openLeft()
                }else{
                    closeLeft()
                }
            }
        }else{
            //向左滑动
            if pan.state == .changed && -offsetX <= self.sideWidth! {
                mainVC?.view.transform = CGAffineTransform(translationX: offsetX, y: 0)
                rightVC?.view.transform = CGAffineTransform(translationX: (offsetX+self.sideWidth!)/2, y: 0)
            }else if pan.state == .cancelled || pan.state == .ended || pan.state == .failed{
                if -offsetX>=sideWidth!/3 {
                    openRight()
                }else{
                    closeRight()
                }
            }
        }
    }
    
    //MARK: - 遮盖层滑动事件
    func panBtnAction(_ pan:UIPanGestureRecognizer) {
        let offsetX = pan.translation(in: pan.view).x
        
        if (mainVC?.view.frame.origin.x)! > CGFloat(0) {
            if offsetX > 0{
                return
            }
            if pan.state == .changed && -offsetX <= sideWidth!{
                mainVC?.view.transform = CGAffineTransform(translationX: offsetX+sideWidth!, y: 0)
                leftVC?.view.transform = CGAffineTransform(translationX: offsetX/2, y: 0)
            }else if pan.state == .cancelled || pan.state == .ended || pan.state == .failed{
                if -offsetX <= sideWidth!/3{
                    openLeft()
                }else{
                    closeLeft()
                }
            }
        }else if (mainVC?.view.frame.origin.x)! < CGFloat(0) {
            if offsetX < 0{
                return
            }
            if pan.state == .changed && offsetX <= sideWidth!{
                mainVC?.view.transform = CGAffineTransform(translationX: offsetX-sideWidth!, y: 0)
                rightVC?.view.transform = CGAffineTransform(translationX: offsetX/2, y: 0)
            }else if pan.state == .cancelled || pan.state == .ended || pan.state == .failed{
                if offsetX <= sideWidth!/3{
                    openRight()
                }else{
                    closeRight()
                }
            }
        }else{
            coverBtn.removeFromSuperview()
        }

    }
    
    func showMainViewAction(_ sender: Notification) {
        closeSide()
    }
    
    //MARK: - 遮盖层按钮
    private lazy var coverBtn:UIButton = {
       let button = UIButton(frame: UIScreen.main.bounds)
        button.backgroundColor = .black
        button.alpha = 0.2
        button.addTarget(self, action: #selector(closeSide), for: .touchUpInside)
        button.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panBtnAction(_:))))
        return button
    }()
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 隐藏状态栏
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
