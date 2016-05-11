//
// Created by Terence Baker on 11/05/2016.
// Copyright (c) 2016 Bulb Studios Ltd. All rights reserved.
//

import UIKit

class ResturantTableDelegate : NSObject, UITableViewDelegate, UITableViewDataSource {

    public var resturantArray = Array<Resturant>()

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        return nil
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return resturantArray.count
    }

}
