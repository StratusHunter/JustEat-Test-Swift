//
// Created by Terence Baker on 11/05/2016.
// Copyright (c) 2016 Bulb Studios Ltd. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Rswift

class ResturantTableDelegate : NSObject, UITableViewDelegate {

    internal var resturantArray = Array<Resturant>()
    private let bag = DisposeBag()

    init(tableView:UITableView) {

        super.init()

        tableView.rx_setDelegate(self)
        .addDisposableTo(bag)

        Observable.just(resturantArray)
        .bindTo(tableView.rx_itemsWithCellIdentifier(R.reuseIdentifier.resturantCell.identifier, cellType:ResturantCell.self)) { (row, element, cell) in

            cell.setupWithResturant(element)
        }
        .addDisposableTo(bag)
    }
}
