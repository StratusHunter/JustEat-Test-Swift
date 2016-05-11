//
// Created by Terence Baker on 11/05/2016.
// Copyright (c) 2016 Bulb Studios Ltd. All rights reserved.
//

import UIKit
import ObjectMapper

class Resturant: Mappable {

    var name = ""
    var address = ""

    required init?(_ map:Map) {

    }

    func mapping(map:Map) {

        name    <- map["Name"]
        address <- map["Address"]
    }
}
