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
    
    func configureCell(with model: Hourly){
        self.timeLabel.text = currentDateFrom(unixDate: model.dt)?.time()
        self.iconImage.image = returnIconImage(from: "01d")
        self.tempLabel.text = "\(model.temp)°"
    }

}
