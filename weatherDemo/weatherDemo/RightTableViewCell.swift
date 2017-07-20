//
//  RightTableViewCell.swift
//  weatherDemo
//
//  Created by wangyu on 19/07/2017.
//  Copyright © 2017 wangyu. All rights reserved.
//

import UIKit

class RightTableViewCell: UITableViewCell {
    @IBOutlet weak var indicatorImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
  
    @IBOutlet weak var deleteImageView: UIImageView!
    
    var controller:UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = leftControllerAndRightControllerBGColor
        
        self.selectionStyle = .none
        
        self.deleteImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(deleteAction(_:)))
        
        self.deleteImageView.addGestureRecognizer(tap)
    }
    
    func deleteAction(_ sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "提示", message: "您是否要删除当前城市「\((self.titleLabel.text)!)」?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler:{
        
            action in
            
                alert.dismiss(animated: true, completion: nil)
            
        })
        
        let comfirmAction = UIAlertAction(title: "确认", style: .default, handler: {
            action in
  
                Helper.deleteCity(city: (self.titleLabel.text)!)
            
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: DeleteHistoryCityNotification), object: nil)

        })
        
        alert.addAction(cancelAction)
        alert.addAction(comfirmAction)
        
        self.controller.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        self.backgroundColor = .gray
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)

        self.backgroundColor = leftControllerAndRightControllerBGColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
