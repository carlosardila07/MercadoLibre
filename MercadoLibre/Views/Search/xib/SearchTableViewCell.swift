//
//  SearchTableViewCell.swift
//  MercadoLibre
//
//  Created by Carlos Ardila on 24/08/22.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productSubtitleLabel: UILabel!
    @IBOutlet weak var freeShippingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
