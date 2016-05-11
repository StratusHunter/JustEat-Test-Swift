//
// Created by Terence Baker on 11/05/2016.
// Copyright (c) 2016 Bulb Studios Ltd. All rights reserved.
//

import UIKit

class ResturantCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    func setupWithResturant(resturant: Resturant) {

        nameLabel.text = resturant.name
        addressLabel.text = resturant.address
    }
}
