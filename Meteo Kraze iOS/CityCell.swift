//
//  CityCellTableViewCell.swift
//  Meteo Kraze iOS
//
//  Created by Guillaume Fourrier on 13/09/2018.
//  Copyright © 2018 Guillaume Fourrier. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {
    
    @IBOutlet weak var currentPosLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    @IBOutlet weak var mainTempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
}
