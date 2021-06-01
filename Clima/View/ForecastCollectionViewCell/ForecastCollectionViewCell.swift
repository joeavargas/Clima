//
//  ForecastCollectionViewCell.swift
//  Clima
//
//  Created by Joe Vargas on 5/22/21.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var tempLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static let identifier = "ForecastCollectionViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "ForecastCollectionViewCell", bundle: nil)
    }
    
    func configureHourly(with hourlyModel: Hourly){
        self.timeLabel.text = currentDateFrom(unixDate: hourlyModel.dt)?.time()
        // TODO: Fix icon retrieval
        for hourlyWeather in hourlyModel.weather{
            self.iconImage.image = returnIconImage(from: hourlyWeather.icon)
        }
        self.tempLabel.text = "\(Int(hourlyModel.temp))°"
    }
    
    func configureDaily(with dailyModel: Daily){
        self.timeLabel.text = currentDateFrom(unixDate: dailyModel.dt)?.dayOfTheWeek()
        // TODO: Fix icon retrieval
        for dailyWeather in dailyModel.weather{
            self.iconImage.image = returnIconImage(from: dailyWeather.icon)
        }
        self.tempLabel.text = "\(Int(dailyModel.temp.max))°"
    }

}
