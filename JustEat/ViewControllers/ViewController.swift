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
import ObjectMapper

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private let bag = DisposeBag()
    private var tableDelegate: ResturantTableDelegate!

    override func viewDidLoad() {

        super.viewDidLoad()

        tableDelegate = ResturantTableDelegate(tableView: tableView)

        subscribeSearchChange()
    }

    private func subscribeSearchChange() {

        //Use rx to monitor text changes in the search bar. Avoids hammering the API using the throttle command and will not perform a search on the same text input.
        searchBar.rx_text
        .throttle(0.6, scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .subscribeNext {
            [unowned self] (postcode) in

            (postcode.characters.count == 0) ? self.clearSearchList() : self.searchWithPostcode(postcode)
        }
        .addDisposableTo(bag)
    }

    //Convienience function to clear the list
    private func clearSearchList() {

        reloadSearchList(Array<Resturant>())
    }

    private func reloadSearchList(resturantArray: [Resturant]) {

        //tableDelegate.resturantArray = resturantArray

        tableView.hidden = (resturantArray.count == 0)
        tableView.reloadData()
    }

    private func searchWithPostcode(postcode: String) {

        guard let observer = JustEatService.resturantSearchObservable(postcode) else {

            return
        }

        observer.observeOn(MainScheduler.instance)
        .subscribe(onNext: { json in

            guard let resturantJSON = json["Restaurants"], let resturants = Mapper<Resturant>().mapArray(resturantJSON) else {

                print("Error parsing JSON")
                return
            }

            self.tableDelegate.setResturantArray(resturants)
        })
        .addDisposableTo(bag)
    }
}
