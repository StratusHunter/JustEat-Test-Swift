//
//  ViewController.swift
//  JustEat
//
//  Created by Terence Baker on 11/05/2016.
//  Copyright (c) 2016 Bulb Studios Ltd. All rights reserved.
//


import UIKit
import RxCocoa
import RxSwift
import RxAlamofire

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private let bag = DisposeBag()
    private let tableDelegate = ResturantTableDelegate()

    override func viewDidLoad() {

        super.viewDidLoad()

        tableView.delegate = tableDelegate
        tableView.dataSource = tableDelegate

        subscribeSearchChange()
    }

    private func subscribeSearchChange() {

        //Use rx to monitor text changes in the search bar. Avoids hammering the API using the throttle command and will not perform a search on the same text input.
        searchBar.rx_text
        .throttle(0.6, scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .subscribeNext {
            [unowned self] (postcode) in

            (postcode.count == 0) ? self.reloadSearchList() : self.searchWithPostcode(postcode)
        }
        .addDisposableTo(self.bag)
    }

    //Convienience function to clear the list
    private func reloadSearchList() {

        reloadSearchList(Array<Resturant>())
    }

    private func reloadSearchList(resturantArray: [Resturant]) {

        tableView.reloadData()
    }

    private func searchWithPostcode(postcode: String) {

        let manager = Manager.sharedInstance
        manager.rx_JSON(.GET, "")
        .observeOn(MainScheduler.instance)
        .subscribe {

        }
    }
}
