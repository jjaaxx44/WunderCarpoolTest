//
//  CarTableCell.swift
//  WunderCarpoolTest
//
//  Created by Abhishek Chaudhari on 30/08/18.
//  Copyright © 2018 Abhishek Chaudhari. All rights reserved.
//

import UIKit

class CarTableCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var fuelLabel: UILabel!
    @IBOutlet weak var engineTypeLabel: UILabel!
    
    @IBOutlet weak var exteriorImageView: UIImageView!
    @IBOutlet weak var interiorImageView: UIImageView!
    
    let goodImage = #imageLiteral(resourceName: "good")//UIImage.init(named: "good")
    let badImage = #imageLiteral(resourceName: "bad")//UIImage.init(named: "bad")

    var carModelView: PlacemarkViewModel? {
        didSet {
            nameLabel.text = carModelView?.nameString
            addressLabel.text = carModelView?.addressString
            fuelLabel.text = carModelView?.fuel
            engineTypeLabel.text = carModelView?.engineTypeString
            
            
            if carModelView?.exterior == "GOOD"{
                exteriorImageView.image = goodImage
            }else{
                exteriorImageView.image = badImage
            }
            
            if carModelView?.interior == "GOOD"{
                interiorImageView.image = goodImage
            }else{
                interiorImageView.image = badImage
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
