//
//  LeftTableViewCell.swift
//  weatherDemo
//
//  Created by wangyu on 18/07/2017.
//  Copyright © 2017 wangyu. All rights reserved.
//

import UIKit

class LeftTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weekDayLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var weatherLabel: UILabel!

    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherBgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        self.backgroundColor = leftControllerAndRightControllerBGColor
        
        self.weatherBgView.layer.cornerRadius = 8.0
        self.weatherBgView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
