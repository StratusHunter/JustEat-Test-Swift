//
// Created by Terence Baker on 11/05/2016.
// Copyright (c) 2016 Bulb Studios Ltd. All rights reserved.
//

import UIKit

class Resturant: Mappable {

    let name : String
    let address : String

    required init?(_ map:Map) {

    }

    func mapping(map:Map) {

        name    <- map["name"]
        address <- map["address"]
    }
}
