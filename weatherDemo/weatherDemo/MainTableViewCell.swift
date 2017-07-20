//
//  MainTableViewCell.swift
//  weatherDemo
//
//  Created by wangyu on 19/07/2017.
//  Copyright © 2017 wangyu. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    
    @IBOutlet weak var messageImageView: UIImageView!

    @IBOutlet weak var animationImageView: UIImageView!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var current_temp_label: UILabel!
    
    @IBOutlet weak var range_temp_label: UILabel!
    
    @IBOutlet weak var windImageView: UIImageView!
    
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var humidityImageView: UIImageView!
    
    @IBOutlet weak var range_humidity_label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
